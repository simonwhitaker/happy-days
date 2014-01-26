//
//  HDMoodButton.m
//  Happy Days
//
//  Created by Simon Whitaker on 20/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDMoodButton.h"

static const CGSize kButtonSize = { 150, 70 };
static const CGFloat kFontSize = 18.0;

@implementation HDMoodButton

- (id)init {
    self = [super init];
    if (self) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kButtonSize.height]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kButtonSize.width]];
        [self setTitleColor:[UIColor colorWithWhite:0 alpha:1.0] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateNormal];
        [self hd_updateAppearance];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self hd_updateAppearance];
}

- (void)hd_updateAppearance {
    self.titleLabel.font = self.selected ? [UIFont fontWithName:@"HelveticaNeue-Bold" size:kFontSize] : [UIFont fontWithName:@"HelveticaNeue-Light" size:kFontSize];
}

@end
