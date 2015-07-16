//
//  HDAppDelegate.m
//  Happy Days
//
//  Created by Simon Whitaker on 16/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDAppDelegate.h"
#import "HDDataController.h"
#import "HDDayViewController.h"
#import "HDNotificationController.h"

@interface HDAppDelegate()
@property (nonatomic) HDDataController *dataController;
@property (nonatomic) HDNotificationController *notificationController;
@property (nonatomic) HDDayViewController *rootDayViewController;
@property (nonatomic) UINavigationController *navigationController;
@end

@implementation HDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    self.dataController = [[HDDataController alloc] init];
    self.notificationController = [[HDNotificationController alloc] init];
    
    HDDayViewController *dayViewController = [[HDDayViewController alloc] init];
    dayViewController.date = [NSDate date];
    dayViewController.dataController = self.dataController;
    dayViewController.notificationController = self.notificationController;
    self.rootDayViewController = dayViewController;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dayViewController];
    
    self.window.rootViewController = navigationController;
    self.navigationController = navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState != UIApplicationStateActive) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // UIUserNotificationType types = [notificationSettings types];
    // TODO: what next?
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    self.rootDayViewController.date = [NSDate date];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
    // TODO: on significant time change we should check to see if the view is foremost; if so, show a dialog asking the user if they want to switch to the new date
    self.rootDayViewController.date = [NSDate date];
}

@end
