//
//  HDDataController.h
//  Happy Days
//
//  Created by Simon Whitaker on 16/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HDMood) {
    HDMoodNotRecorded,
    HDMoodSad,
    HDMoodIndifferent,
    HDMoodHappy
};

@interface HDDataController : NSObject

- (void)setMood:(HDMood)mood ForDate:(NSDate*)date;
- (HDMood)moodForDate:(NSDate*) date;

@end
