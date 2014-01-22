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
        dayNumberLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        dayNumberLabel.minimumScaleFactor = 0.1;
        dayNumberLabel.textAlignment = NSTextAlignmentCenter;
        dayNumberLabel.layer.cornerRadius = 20;
        [self addSubview:dayNumberLabel];
        self.dayNumberLabel = dayNumberLabel;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(dayNumberLabel);
        NSDictionary *metrics = @{ @"padding": @2 };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-padding-[dayNumberLabel]-padding-|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[dayNumberLabel]-padding-|" options:0 metrics:metrics views:views]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
