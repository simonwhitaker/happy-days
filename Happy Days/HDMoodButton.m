//
//  HDMoodButton.m
//  Happy Days
//
//  Created by Simon Whitaker on 20/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDMoodButton.h"

static const CGFloat kFontSize = 48.0;

@interface HDMoodButton()
@property (nonatomic) NSMutableDictionary *backgroundColorsByState;
@end

@implementation HDMoodButton

- (id)init {
    self = [super init];
    if (self) {
        _backgroundColorsByState = [NSMutableDictionary dictionary];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        self.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
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
    self.titleLabel.font = self.selected ? [UIFont fontWithName:@"HelveticaNeue-Thin" size:kFontSize] : [UIFont fontWithName:@"HelveticaNeue-Thin" size:kFontSize];
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
