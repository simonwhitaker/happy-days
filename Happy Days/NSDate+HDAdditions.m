//
//  NSDate+HDAdditions.m
//  Happy Days
//
//  Created by Simon Whitaker on 22/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "NSDate+HDAdditions.h"

@implementation NSDate (HDAdditions)

- (bool)hd_isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *selfDateComps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    NSDateComponents *todayDateComps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    return [selfDateComps isEqual:todayDateComps];
}

@end
