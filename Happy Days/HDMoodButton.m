//
//  HDMoodButton.m
//  Happy Days
//
//  Created by Simon Whitaker on 20/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDMoodButton.h"

static const CGSize kButtonSize = { 220, 70 };
static const CGFloat kFontSize = 20.0;

@interface HDMoodButton()
@property (nonatomic) NSMutableDictionary *backgroundColorsByState;
@end

@implementation HDMoodButton

- (id)init {
    self = [super init];
    if (self) {
        _backgroundColorsByState = [NSMutableDictionary dictionary];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kButtonSize.height]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kButtonSize.width]];
        self.layer.cornerRadius = 4.0;
        [self hd_updateAppearance];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self hd_updateAppearance];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    self.backgroundColorsByState[@(state)] = backgroundColor;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self hd_updateAppearance];
}

- (void)hd_updateAppearance {
    self.titleLabel.font = self.selected ? [UIFont fontWithName:@"HelveticaNeue" size:kFontSize] : [UIFont fontWithName:@"HelveticaNeue-Light" size:kFontSize];
    UIControlState state;

    if (!self.enabled) {
        state = UIControlStateDisabled;
    }
    else if (self.selected) {
        state = UIControlStateSelected;
    }
    else if (self.highlighted) {
        state = UIControlStateHighlighted;
    }
    else {
        state = UIControlStateNormal;
    }
    
    UIColor *backgroundColor = self.backgroundColorsByState[@(state)];
    if (!backgroundColor) {
        backgroundColor = self.backgroundColorsByState[@(UIControlStateNormal)];
    }
    if (!backgroundColor) {
        backgroundColor = self.backgroundColor;
    }
    self.backgroundColor = backgroundColor;
}

@end
