//
//  HDCalendarMonthHeader.m
//  Happy Days
//
//  Created by Simon Whitaker on 22/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDCalendarMonthHeader.h"

@interface HDCalendarMonthHeader()
@property (nonatomic) NSLayoutConstraint *topLayoutConstraint;
@property (nonatomic) NSLayoutConstraint *leftLayoutConstraint;
@property (nonatomic) NSLayoutConstraint *rightLayoutConstraint;
@property (nonatomic) NSLayoutConstraint *bottomLayoutConstraint;
@end

@implementation HDCalendarMonthHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        self.topLayoutConstraint = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        self.leftLayoutConstraint = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        self.rightLayoutConstraint = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        self.bottomLayoutConstraint = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        [self addConstraints:@[self.topLayoutConstraint, self.leftLayoutConstraint, self.rightLayoutConstraint, self.bottomLayoutConstraint]];
    }
    return self;
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(edgeInsets, _edgeInsets)) {
        _edgeInsets = edgeInsets;
        
        self.topLayoutConstraint.constant = _edgeInsets.top;
        self.leftLayoutConstraint.constant = _edgeInsets.left;
        self.rightLayoutConstraint.constant = 0 - _edgeInsets.right;
        self.bottomLayoutConstraint.constant = 0 - _edgeInsets.bottom;
    }
}

@end
