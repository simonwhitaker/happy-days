//
//  HDNotificationController.m
//  Happy Days
//
//  Created by Simon Whitaker on 19/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDNotificationController.h"

static NSString *const kLocalNotificationsEnabledUserDefaultsKey = @"org.netcetera.happydays.notificationsEnabled";

@implementation HDNotificationController

- (id)init {
    self = [super init];
    if (self) {
        _localNotificationEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kLocalNotificationsEnabledUserDefaultsKey];
    }
    return self;
}

- (void)setLocalNotificationEnabled:(bool)localNotificationEnabled {
    if (localNotificationEnabled != _localNotificationEnabled) {
        _localNotificationEnabled = localNotificationEnabled;
        [[NSUserDefaults standardUserDefaults] setBool:_localNotificationEnabled forKey:kLocalNotificationsEnabledUserDefaultsKey];
        
        if (_localNotificationEnabled) {
            NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
            NSDateComponents *dateComponents = [calendar components:(NSCalendarUnit)(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:[NSDate date]];
            dateComponents.hour = 21;
            NSDate *fireDate = [calendar dateFromComponents:dateComponents];
            
            if ([fireDate compare:[NSDate date]] == NSOrderedAscending) {
                // fireDate is in the past, add a day
                NSDateComponents *oneDay = [[NSDateComponents alloc] init];
                oneDay.day = 1;
                fireDate = [calendar dateByAddingComponents:oneDay toDate:fireDate options:0];
            }
            
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

@end
