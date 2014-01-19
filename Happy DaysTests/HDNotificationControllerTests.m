//
//  HDNotificationControllerTests.m
//  Happy Days
//
//  Created by Simon Whitaker on 19/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HDNotificationController.h"

@interface HDNotificationController(Tests)
- (NSDate*)hd_fireDateForDate:(NSDate*)date;
@end

@interface HDNotificationControllerTests : XCTestCase

@end

@implementation HDNotificationControllerTests

- (void)testFireDateForDate
{
    HDNotificationController *notificationController = [[HDNotificationController alloc] init];
    notificationController.timeMinutes = 12*60; // midday
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    dateComps.year = 2014;
    dateComps.month = 1;
    dateComps.day = 1;
    dateComps.hour = 11;
    dateComps.minute = 59;
    
    NSDate *date = [calendar dateFromComponents:dateComps];
    NSDate *fireDate = [notificationController hd_fireDateForDate:date];
    NSDateComponents *fireDateComps = [calendar components:(NSCalendarUnit)(NSCalendarUnitMinute|NSCalendarUnitHour|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:fireDate];
    
    XCTAssertEqual(fireDateComps.year, dateComps.year, @"Year of fireDate is set correctly");
    XCTAssertEqual(fireDateComps.month, dateComps.month, @"Month of fireDate is set correctly");
    XCTAssertEqual(fireDateComps.day, dateComps.day, @"Day of fireDate is set correctly");
    XCTAssertEqual(fireDateComps.hour, (NSInteger)(notificationController.timeMinutes/60), @"Hour of fire date is set correctly");
    XCTAssertEqual(fireDateComps.minute, (NSInteger)(notificationController.timeMinutes%60), @"Minute of fire date is set correctly");
    
    dateComps.hour = 12;
    dateComps.minute = 0;

    date = [calendar dateFromComponents:dateComps];
    fireDate = [notificationController hd_fireDateForDate:date];
    fireDateComps = [calendar components:(NSCalendarUnit)(NSCalendarUnitMinute|NSCalendarUnitHour|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:fireDate];
    
    XCTAssertEqual(fireDateComps.year, dateComps.year, @"Year of fireDate is set correctly");
    XCTAssertEqual(fireDateComps.month, dateComps.month, @"Month of fireDate is set correctly");
    XCTAssertEqual(fireDateComps.day, dateComps.day, @"Day of fireDate is set correctly");
    XCTAssertEqual(fireDateComps.hour, (NSInteger)(notificationController.timeMinutes/60), @"Hour of fire date is set correctly");
    XCTAssertEqual(fireDateComps.minute, (NSInteger)(notificationController.timeMinutes%60), @"Minute of fire date is set correctly");
    
    dateComps.hour = 12;
    dateComps.minute = 1;
    
    date = [calendar dateFromComponents:dateComps];
    fireDate = [notificationController hd_fireDateForDate:date];
    fireDateComps = [calendar components:(NSCalendarUnit)(NSCalendarUnitMinute|NSCalendarUnitHour|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:fireDate];
    
    XCTAssertEqual(fireDateComps.year, dateComps.year, @"Year of fireDate is set correctly");
    XCTAssertEqual(fireDateComps.month, dateComps.month, @"Month of fireDate is set correctly");
    XCTAssertEqual(fireDateComps.day, dateComps.day + 1, @"Day of fireDate is set correctly");
    XCTAssertEqual(fireDateComps.hour, (NSInteger)(notificationController.timeMinutes/60), @"Hour of fire date is set correctly");
    XCTAssertEqual(fireDateComps.minute, (NSInteger)(notificationController.timeMinutes%60), @"Minute of fire date is set correctly");
}

@end
