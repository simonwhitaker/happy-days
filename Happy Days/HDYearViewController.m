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
#import "HDDayViewController.h"

#import "NSDate+HDAdditions.h"

static NSString *const kCalendarDayViewIdentifier = @"CalendarDayViewIdentifier";
static NSString *const kCalendarMonthHeaderIdentifier = @"CalendarMonthHeaderIdentifier";

@interface HDYearViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSCalendar *calendar;
@property (nonatomic) NSCache *numberOfSpacersForSectionCache;

@end

@implementation HDYearViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self.collectionView registerClass:[HDCalendarDayCell class] forCellWithReuseIdentifier:kCalendarDayViewIdentifier];
        [self.collectionView registerClass:[HDCalendarMonthHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCalendarMonthHeaderIdentifier];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        _numberOfSpacersForSectionCache = [[NSCache alloc] init];
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
    [self.numberOfSpacersForSectionCache removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isMovingToParentViewController) {
        NSIndexPath *indexPath = [self hd_indexPathForDate:[NSDate date]];
        if (indexPath) {
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCalendarDayViewIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.collectionView.backgroundColor;
    
    NSInteger day = indexPath.item - [self hd_numberOfSpacerCellsForSection:indexPath.section] + 1;
    
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
    return range.length + [self hd_numberOfSpacerCellsForSection:section];
}

#pragma mark - UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(44.0, 44.0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.frame.size.width, 30.0);
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = [self hd_dateForIndexPath:indexPath];
    if (date) {
        HDDayViewController *vc = [[HDDayViewController alloc] init];
        vc.date = date;
        vc.dataController = self.dataController;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Private methods

- (NSIndexPath*)hd_indexPathForDate:(NSDate*)date {
    NSDateComponents *dateComps = [self.calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    if (dateComps.year == self.year) {
        NSInteger section = dateComps.month - 1;
        NSInteger item = dateComps.day - 1 + [self hd_numberOfSpacerCellsForSection:section];
        return [NSIndexPath indexPathForItem:item inSection:section];
    }
    return nil;
}

- (NSDate*)hd_dateForIndexPath:(NSIndexPath*)indexPath {
    NSInteger numberOfSpacersThisSection = [self hd_numberOfSpacerCellsForSection:indexPath.section];
    
    if (indexPath.row < numberOfSpacersThisSection) {
        return nil;
    }
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    dateComps.year = self.year;
    dateComps.month = indexPath.section + 1;
    dateComps.day = indexPath.row + 1 - numberOfSpacersThisSection;
    NSDate *date = [self.calendar dateFromComponents:dateComps];
    return date;
}

- (NSInteger)hd_numberOfSpacerCellsForSection:(NSInteger)section {
    NSNumber *cacheResult = [self.numberOfSpacersForSectionCache objectForKey:@(section)];
    if (cacheResult) {
        return [cacheResult integerValue];
    }
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    dateComps.year = self.year;
    dateComps.day = 1;
    dateComps.month = section + 1;
    
    NSDate *date = [self.calendar dateFromComponents:dateComps];
    dateComps = [self.calendar components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = dateComps.weekday;
    
    static NSInteger startOfWeekDay = 2; // Monday in Gregorian calendar
    // If weekday == startOfWeekDay we want 0 spacers. If weekday == startOfWeekDay + 1 we want 1 spacer, etc
    NSInteger result = (weekday + 7 - startOfWeekDay) % 7;
    [self.numberOfSpacersForSectionCache setObject:@(result) forKey:@(section)];
    return result;
}

@end
