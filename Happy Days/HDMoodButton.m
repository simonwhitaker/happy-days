//
//  HDMoodButton.m
//  Happy Days
//
//  Created by Simon Whitaker on 20/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDMoodButton.h"

const CGSize kSize = { 120, 70 };

@implementation HDMoodButton

- (id)init {
    self = [super init];
    if (self) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kSize.height]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kSize.width]];
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        [self setTitleColor:[UIColor colorWithWhite:0.1 alpha:1.0] forState:UIControlStateNormal];
        self.layer.cornerRadius = MIN(kSize.width, kSize.height) / 2;
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self hd_updateAppearance];
}

- (void)hd_updateAppearance {
    self.backgroundColor = self.selected ? self.tintColor : [UIColor colorWithWhite:0.9 alpha:1.0];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    [self hd_updateAppearance];
}

@end
