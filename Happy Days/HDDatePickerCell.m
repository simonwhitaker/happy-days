//
//  HDDatePickerCell.m
//  Happy Days
//
//  Created by Simon Whitaker on 08/02/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDDatePickerCell.h"

@implementation HDDatePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:datePicker];
        self.datePicker = datePicker;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(datePicker);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[datePicker]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[datePicker]|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
