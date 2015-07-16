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
            kUserDefaultsKeyLocalNotificationsEnabled: @(false),
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
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [self hd_scheduleLocalNotificationWithCurrentSettings];
        }
        else {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
    }
}

- (void)setTimeMinutes:(NSUInteger)timeMinutes {
    if (timeMinutes != _timeMinutes) {
        _timeMinutes = timeMinutes;
        if (self.isLocalNotificationEnabled) {
            [self hd_scheduleLocalNotificationWithCurrentSettings];
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

- (void)hd_scheduleLocalNotificationWithCurrentSettings {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSDate *fireDate = [self hd_fireDateForDate:[NSDate date]];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertAction = @"Tell Me";
    notification.alertBody = @"How was today?";
    notification.timeZone = [NSTimeZone localTimeZone];
    notification.fireDate = fireDate;
    notification.repeatInterval = NSCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    [self hd_debugPrintAllScheduledLocalNotifications];
}

- (void)hd_debugPrintAllScheduledLocalNotifications {
    NSArray *scheduledLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"%lu local notification(s) scheduled", (unsigned long)[scheduledLocalNotifications count]);
    [scheduledLocalNotifications enumerateObjectsUsingBlock:^(UILocalNotification *localNotification, NSUInteger idx, BOOL *stop) {
        NSLog(@"%lu: %@, fires at %@, repeat interval = %lu", (unsigned long)(idx + 1), localNotification.alertBody, localNotification.fireDate, (unsigned long)(localNotification.repeatInterval));
    }];
}

@end
