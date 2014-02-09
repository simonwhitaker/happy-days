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
#import "HDSettingsViewController.h"
#import "HDDismissableViewControllerDelegate.h"

@interface HDAppDelegate() <HDDismissableViewControllerDelegate>
@property (nonatomic) HDDataController *dataController;
@property (nonatomic) HDNotificationController *notificationController;
@property (nonatomic) HDDayViewController *rootDayViewController;
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
    
    dayViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"740-gear"] style:UIBarButtonItemStylePlain target:self action:@selector(hd_handleSettingsButton:)];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dayViewController];
    
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    self.rootDayViewController.date = [NSDate date];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
    // TODO: on significant time change we should check to see if the view is foremost; if so, show a dialog asking the user if they want to switch to the new date
    self.rootDayViewController.date = [NSDate date];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)hd_handleSettingsButton:(id)sender {
    HDSettingsViewController *vc = [[HDSettingsViewController alloc] init];
    vc.notificationController = self.notificationController;
    vc.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window.rootViewController presentViewController:nc animated:YES completion:nil];
}

#pragma mark - HDDismissableViewControllerDelegate methods

- (void)viewControllerShouldDismiss:(UIViewController *)viewController wasCancelled:(bool)wasCancelled {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
