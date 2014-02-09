//
//  NSDate+HDAdditions.h
//  Happy Days
//
//  Created by Simon Whitaker on 22/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HDAdditions)

- (bool)hd_isToday;
- (bool)hd_isTodayOrEarlier;

@end
