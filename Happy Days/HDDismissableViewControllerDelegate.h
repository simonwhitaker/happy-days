//
//  HDDismissableViewControllerDelegate.h
//  Happy Days
//
//  Created by Simon Whitaker on 08/02/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HDDismissableViewControllerDelegate <NSObject>

- (void)viewControllerShouldDismiss:(UIViewController*)viewController wasCancelled:(bool)wasCancelled;

@end
