//
//  HDCalendarDayCell.m
//  Happy Days
//
//  Created by Simon Whitaker on 22/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDCalendarDayCell.h"

@implementation HDCalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *dayNumberLabel = [[UILabel alloc] init];
        dayNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        dayNumberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dayNumberLabel];
        self.dayNumberLabel = dayNumberLabel;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(dayNumberLabel);
        NSDictionary *metrics = @{ @"padding": @0 };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-padding-[dayNumberLabel]-padding-|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[dayNumberLabel]-padding-|" options:0 metrics:metrics views:views]];
    }
    return self;
}

@end
