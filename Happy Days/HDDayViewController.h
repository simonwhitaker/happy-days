//
//  HDDayViewController.h
//  Happy Days
//
//  Created by Simon Whitaker on 19/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDDataController.h"
#import "HDNotificationController.h"

@interface HDDayViewController : UIViewController

/// The date to use for this day view controller. If nil, the current date is used.
@property (nonatomic) NSDate *date;

@property (nonatomic) HDDataController *dataController;
@property (nonatomic) HDNotificationController *notificationController;

@end
