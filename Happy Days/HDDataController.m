//
//  HDDataController.m
//  Happy Days
//
//  Created by Simon Whitaker on 16/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDDataController.h"

@interface HDDataController()
@property (nonatomic) NSMutableDictionary *moodsByYear;
@end

@implementation HDDataController

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hd_handleLowMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        self.moodsByYear = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setMood:(HDMood)mood ForDate:(NSDate *)date {
    NSMutableDictionary *dictionary = [self hd_dictionaryForDate:date];
    NSString *dateString = [self hd_dateStringForDate:date];
    dictionary[dateString] = @(mood);
}

- (HDMood)moodForDate:(NSDate *)date {
    NSMutableDictionary *dictionary = [self hd_dictionaryForDate:date];
    NSString *dateString = [self hd_dateStringForDate:date];
    NSNumber *resultObj = dictionary[dateString];
    if (resultObj) {
        return (HDMood)[resultObj unsignedIntegerValue];
    }
    return HDMoodNotRecorded;
}

- (NSMutableDictionary*)hd_dictionaryForDate:(NSDate*)date {
    NSString *year = [self hd_yearStringForDate:date];
    NSMutableDictionary *result = self.moodsByYear[year];
    if (!result) {
        result = [NSMutableDictionary dictionary];
        self.moodsByYear[year] = result;
    }
    return result;
}

- (NSString*)hd_yearStringForDate:(NSDate*)date {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy";
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    }
    return [dateFormatter stringFromDate:date];
}

- (NSString*)hd_dateStringForDate:(NSDate*)date {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    }
    return [dateFormatter stringFromDate:date];
}

- (void)hd_handleLowMemoryWarning:(NSNotification*)notification {
    [self.moodsByYear removeAllObjects];
}

@end
