//
//  HDNotificationController.h
//  Happy Days
//
//  Created by Simon Whitaker on 19/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDNotificationController : NSObject

@property (nonatomic) NSUInteger timeMinutes;
@property (nonatomic, getter = isLocalNotificationEnabled) bool localNotificationEnabled;

- (void)postponeUntilTomorrow;

@end
