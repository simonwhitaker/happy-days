//
//  HDSettingsViewController.h
//  Happy Days
//
//  Created by Simon Whitaker on 08/02/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDNotificationController.h"
#import "HDDismissableViewControllerDelegate.h"

@interface HDSettingsViewController : UITableViewController

@property (nonatomic) HDNotificationController *notificationController;
@property (nonatomic, weak) id<HDDismissableViewControllerDelegate> delegate;

@end
