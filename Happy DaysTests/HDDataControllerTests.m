//
//  HDDataControllerTests.m
//  Happy Days
//
//  Created by Simon Whitaker on 16/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

@import XCTest;
#import "HDDataController.h"

@interface HDDataControllerTests : XCTestCase

@end

@implementation HDDataControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testAccessors
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnit)(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:now];
    NSDate *startOfToday = [calendar dateFromComponents:dateComponents];
    
    HDDataController *dataController = [[HDDataController alloc] init];
    XCTAssertEqual([dataController moodForDate:now], HDMoodNotRecorded, @"Mood is not recorded at startup");
    
    HDMood mood = HDMoodHappy;
    [dataController setMood:mood ForDate:now];
    XCTAssertEqual([dataController moodForDate:now], mood, @"Mood is set correctly");
    XCTAssertEqual([dataController moodForDate:startOfToday], mood, @"Mood is set correctly for start of today");
    
    NSDate *yesterday = [startOfToday dateByAddingTimeInterval:-1];
    XCTAssertEqual([dataController moodForDate:yesterday], HDMoodNotRecorded, @"Mood is not recorded for yesterday");
    
}

@end
