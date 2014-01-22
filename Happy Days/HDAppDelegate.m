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
@end

@implementation HDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    UIColor *tintColor = [UIColor colorWithRed:1.000 green:0.591 blue:0.000 alpha:1.000];
    [UIView appearance].tintColor = tintColor;
    [UISwitch appearance].onTintColor = tintColor;
    self.window.tintColor = tintColor;
    
    self.dataController = [[HDDataController alloc] init];
    self.notificationController = [[HDNotificationController alloc] init];
    self.notificationController.timeMinutes = 60 * 21; // 9pm
    
    HDDayViewController *dayViewController = [[HDDayViewController alloc] init];
    dayViewController.dataController = self.dataController;
    dayViewController.notificationController = self.notificationController;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dayViewController];
    
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
