//
//  HDNotificationController.m
//  Happy Days
//
//  Created by Simon Whitaker on 19/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDNotificationController.h"

static NSString *const kUserDefaultsKeyLocalNotificationsEnabled = @"org.netcetera.happydays.notificationsEnabled";
static NSString *const kUserDefaultsKeyLocalNotificationsTimeMinutes = @"org.netcetera.happydays.notificationsTimeMinutes";

@interface HDNotificationController()
@property (nonatomic, strong) NSCalendar *calendar;
@end

@implementation HDNotificationController

- (id)init {
    self = [super init];
    if (self) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{
            kUserDefaultsKeyLocalNotificationsEnabled: @(true),
            kUserDefaultsKeyLocalNotificationsTimeMinutes: @(21*60),
        }];
        _localNotificationEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyLocalNotificationsEnabled];
        _timeMinutes = [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsKeyLocalNotificationsTimeMinutes];
        _calendar = [NSCalendar autoupdatingCurrentCalendar];
    }
    return self;
}

- (void)setLocalNotificationEnabled:(bool)localNotificationEnabled {
    if (localNotificationEnabled != _localNotificationEnabled) {
        _localNotificationEnabled = localNotificationEnabled;
        [[NSUserDefaults standardUserDefaults] setBool:_localNotificationEnabled forKey:kUserDefaultsKeyLocalNotificationsEnabled];
        
        if (_localNotificationEnabled) {
            NSDate *fireDate = [self hd_fireDateForDate:[NSDate date]];
            
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.alertAction = @"Tell Me";
            notification.alertBody = @"How was today?";
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.fireDate = fireDate;
            notification.repeatInterval = NSCalendarUnitDay;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
    }
}

- (void)postponeUntilTomorrow {
    UILocalNotification *notification = [[[UIApplication sharedApplication] scheduledLocalNotifications] firstObject];
    if (notification) {
        NSDateComponents *oneDay = [[NSDateComponents alloc] init];
        oneDay.day = 1;
        
        NSDateComponents *todayComps = [self.calendar components:(NSCalendarUnit)(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:[NSDate date]];
        NSDate *today = [self.calendar dateFromComponents:todayComps];
        NSDate *tomorrow = [self.calendar dateByAddingComponents:oneDay toDate:today options:0];
        NSDate *fireDate = [self hd_fireDateForDate:tomorrow];
        notification.fireDate = fireDate;
    }
}

#pragma mark - Private methods

/// Returns the next fire date that is after `date`
- (NSDate*)hd_fireDateForDate:(NSDate*)date {
    NSDateComponents *dateComps = [self.calendar components:(NSCalendarUnit)(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:date];
    dateComps.hour = self.timeMinutes / 60;
    dateComps.minute = self.timeMinutes % 60;
    NSDate *fireDate = [self.calendar dateFromComponents:dateComps];
    
    if ([fireDate compare:date] == NSOrderedAscending) {
        // fireDate is earlier than date, add a day
        NSDateComponents *oneDay = [[NSDateComponents alloc] init];
        oneDay.day = 1;
        fireDate = [self.calendar dateByAddingComponents:oneDay toDate:fireDate options:0];
    }

    return fireDate;
}

@end
