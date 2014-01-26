//
//  HDYearViewController.m
//  Happy Days
//
//  Created by Simon Whitaker on 22/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDYearViewController.h"
#import "HDCalendarDayCell.h"
#import "HDCalendarMonthHeader.h"
#import "NSDate+HDAdditions.h"

static NSString *const kCalendarDayViewIdentifier = @"CalendarDayViewIdentifier";
static NSString *const kCalendarMonthHeaderIdentifier = @"CalendarMonthHeaderIdentifier";

@interface HDYearViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSCalendar *calendar;

@end

@implementation HDYearViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self.collectionView registerClass:[HDCalendarDayCell class] forCellWithReuseIdentifier:kCalendarDayViewIdentifier];
        [self.collectionView registerClass:[HDCalendarMonthHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCalendarMonthHeaderIdentifier];
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (void)setYear:(NSInteger)year {
    _year = year;
    self.title = [NSString stringWithFormat:@"%li", (long)_year];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isMovingToParentViewController) {
        NSUInteger dayInYear = [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:[NSDate date]];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:dayInYear inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCalendarDayViewIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.collectionView.backgroundColor;
    
    NSInteger day = indexPath.item - [self numberOfSpacerCellsForSection:indexPath.section] + 1;
    
    if (day > 0) {
        NSDateComponents *dateComps = [[NSDateComponents alloc] init];
        dateComps.year = self.year;
        dateComps.month = indexPath.section + 1;
        dateComps.day = day;
        NSDate *date = [self.calendar dateFromComponents:dateComps];
        
        HDMood mood = [self.dataController moodForDate:date];
        if (mood != HDMoodNotRecorded) {
            UIColor *backgroundColor = self.collectionView.backgroundColor;
            switch (mood) {
                case HDMoodGood:
                    backgroundColor = [UIColor colorWithRed:0.780 green:0.941 blue:0.620 alpha:1.000];
                    break;
                case HDMoodAverage:
                    backgroundColor = [UIColor colorWithRed:1.000 green:0.965 blue:0.678 alpha:1.000];
                    break;
                case HDMoodBad:
                    backgroundColor = [UIColor colorWithRed:0.980 green:0.647 blue:0.616 alpha:1.000];
                    break;
                default:
                    break;
            }
            cell.dayNumberLabel.backgroundColor = backgroundColor;
        }

        cell.dayNumberLabel.text = [NSString stringWithFormat:@"%li", (long)day];
        cell.dayNumberLabel.font = [date hd_isToday] ? [UIFont fontWithName:@"HelveticaNeue-Bold" size:16] : [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    static NSDateFormatter *monthFormatter = nil;
    if (!monthFormatter) {
        monthFormatter = [[NSDateFormatter alloc] init];
        monthFormatter.dateFormat = @"MMMM yyyy";
    }
    if (kind == UICollectionElementKindSectionHeader) {
        HDCalendarMonthHeader *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCalendarMonthHeaderIdentifier forIndexPath:indexPath];
        monthHeader.edgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);
        
        NSDateComponents *dateComps = [[NSDateComponents alloc] init];
        dateComps.year = self.year;
        dateComps.month = indexPath.section + 1;
        dateComps.day = 1;
        NSDate *date = [self.calendar dateFromComponents:dateComps];

        monthHeader.titleLabel.text = [monthFormatter stringFromDate:date];
        monthHeader.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        monthHeader.titleLabel.tintColor = self.view.tintColor;
        
        return monthHeader;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.calendar maximumRangeOfUnit:NSCalendarUnitMonth].length;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    // Get first day of month
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    dateComps.day = 1;
    dateComps.month = section + 1;
    dateComps.year = self.year + 1;
    NSDate *date = [self.calendar dateFromComponents:dateComps];

    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length + [self numberOfSpacerCellsForSection:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [self cellWidthForColumn:indexPath.item % 7];
    return CGSizeMake(width, 44.0);
}

- (NSInteger)numberOfSpacerCellsForSection:(NSInteger)section {
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    dateComps.year = self.year;
    dateComps.day = 1;
    dateComps.month = section + 1;
    
    NSDate *date = [self.calendar dateFromComponents:dateComps];
    dateComps = [self.calendar components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = dateComps.weekday;
    
    static NSInteger startOfWeekDay = 2; // Monday in Gregorian calendar
    // If weekday == startOfWeekDay we want 0 spacers. If weekday == startOfWeekDay + 1 we want 1 spacer, etc
    return (weekday + 7 - startOfWeekDay) % 7;
}

- (CGFloat)cellWidthForColumn:(NSInteger)columnIndex {
    return (columnIndex == 0 || columnIndex == 6) ? 45.0 : 46.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.frame.size.width, 30.0);
}

@end
