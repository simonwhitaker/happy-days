//
//  HDYearViewController.m
//  Happy Days
//
//  Created by Simon Whitaker on 22/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDYearViewController.h"
#import "HDCalendarDayCell.h"
#import "NSDate+HDAdditions.h"

static NSString *const kCalendarDayViewIdentifier = @"kCalendarDayViewIdentifier";

@interface HDYearViewController () <UICollectionViewDelegateFlowLayout>

@end

@implementation HDYearViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self.collectionView registerClass:[HDCalendarDayCell class] forCellWithReuseIdentifier:kCalendarDayViewIdentifier];
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setYear:(NSInteger)year {
    _year = year;
    self.title = [NSString stringWithFormat:@"%li", (long)_year];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isMovingToParentViewController) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger dayInYear = [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:[NSDate date]];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:dayInYear inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCalendarDayViewIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.collectionView.backgroundColor;
    
    if (indexPath.item) {
        NSInteger dayInYear = indexPath.item;
        NSDateComponents *dateComps = [[NSDateComponents alloc] init];
        dateComps.year = self.year;
        dateComps.day = dayInYear;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *date = [calendar dateFromComponents:dateComps];
        
        dateComps = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
        
        UIColor *backgroundColor;
        HDMood mood = [self.dataController moodForDate:date];
        if (mood != HDMoodNotRecorded) {
            switch (mood) {
                case HDMoodGood:
                    backgroundColor = [UIColor greenColor];
                    break;
                case HDMoodAverage:
                    backgroundColor = [UIColor orangeColor];
                    break;
                case HDMoodBad:
                    backgroundColor = [UIColor redColor];
                    break;
                default:
                    break;
            }
        }
        else if ([date hd_isToday]) {
            backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        }
        else if (dateComps.month % 2) {
            backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        }
        else {
            backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
        }
        cell.dayNumberLabel.text = [NSString stringWithFormat:@"%li", (long)(dateComps.day)];
        cell.dayNumberLabel.backgroundColor = backgroundColor;
    } else {
        cell.dayNumberLabel.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    // Get first day of next year
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    dateComps.day = 1;
    dateComps.year = self.year + 1;
    NSDate *date = [calendar dateFromComponents:dateComps];
    
    // Now get last day of current year by subtracting one day
    NSDateComponents *minusOneDay = [[NSDateComponents alloc] init];
    minusOneDay.day = -1;
    date = [calendar dateByAddingComponents:minusOneDay toDate:date options:0];
    
    // Now get the number of days in the year
    NSUInteger daysInYear = [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
    
    return daysInYear + 1; // +1 for the spacer
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        // item 0 is a spacer just to get the rest of the year aligned on start-of-week boundaries
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComps = [[NSDateComponents alloc] init];
        dateComps.year = self.year;
        dateComps.day = 1;
        dateComps.month = 1;
        NSDate *date = [calendar dateFromComponents:dateComps];
        dateComps = [calendar components:NSCalendarUnitWeekday fromDate:date];
        
        NSInteger requiredSpaceInDays = (dateComps.weekday + 5) % 7; // Monday is 0, Monday is 1, etc.
        CGFloat width = 0;
        if (requiredSpaceInDays) {
            width = 44.0 * requiredSpaceInDays + 2.0 * (requiredSpaceInDays - 1);
        }
        return CGSizeMake(width, 44.0);
    }
    return CGSizeMake(44.0, 44.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

@end
