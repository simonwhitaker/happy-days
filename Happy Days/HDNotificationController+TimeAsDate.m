//
//  HDNotificationController+TimeAsDate.m
//  Happy Days
//
//  Created by Simon Whitaker on 08/02/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDNotificationController+TimeAsDate.h"

@implementation HDNotificationController (TimeAsDate)

- (NSDate *)notificationTimeAsDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.hour = self.timeMinutes / 60;
    comps.minute = self.timeMinutes % 60;
    return [calendar dateFromComponents:comps];
}

- (void)setNotificationTimeAsDate:(NSDate *)notificationTimeAsDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:notificationTimeAsDate];
    self.timeMinutes = comps.hour * 60 + comps.minute;
}

@end
