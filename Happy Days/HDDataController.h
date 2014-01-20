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
    HDMoodBad,
    HDMoodAverage,
    HDMoodGood,
    
};

@interface HDDataController : NSObject

/// shouldPersistData: true by default
@property (nonatomic) bool shouldPersistData;

- (void)setMood:(HDMood)mood ForDate:(NSDate*)date;
- (HDMood)moodForDate:(NSDate*) date;

@end
