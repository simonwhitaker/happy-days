//
//  HDDayViewController.m
//  Happy Days
//
//  Created by Simon Whitaker on 19/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDDayViewController.h"

@interface HDDayViewController ()
@property (nonatomic) UIButton *goodButton;
@property (nonatomic) UIButton *averageButton;
@property (nonatomic) UIButton *badButton;
@property (nonatomic) NSArray *buttons;
@end

@implementation HDDayViewController

- (void)loadView {
    UIView *rootView = [[UIView alloc] init];
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hd_setupSubviews];
}

- (void)hd_setupSubviews {

    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"How was today?";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *goodButton = [UIButton buttonWithType:UIButtonTypeSystem];
    goodButton.translatesAutoresizingMaskIntoConstraints = NO;
    goodButton.tag = HDMoodGood;
    [goodButton setTitle:@"Good" forState:UIControlStateNormal];
    [goodButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [goodButton addTarget:self action:@selector(hd_handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goodButton];
    
    UIButton *averageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    averageButton.translatesAutoresizingMaskIntoConstraints = NO;
    averageButton.tag = HDMoodAverage;
    [averageButton setTitle:@"Average" forState:UIControlStateNormal];
    [averageButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [averageButton addTarget:self action:@selector(hd_handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:averageButton];
    
    UIButton *badButton = [UIButton buttonWithType:UIButtonTypeSystem];
    badButton.translatesAutoresizingMaskIntoConstraints = NO;
    badButton.tag = HDMoodBad;
    [badButton setTitle:@"Bad" forState:UIControlStateNormal];
    [badButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [badButton addTarget:self action:@selector(hd_handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:badButton];
    
    self.buttons = @[ goodButton, averageButton, badButton ];
    
    id topGuide = self.topLayoutGuide;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(topGuide, label, goodButton, averageButton, badButton);
    NSDictionary *metrics = @{ @"buttonSpacing": @30 };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-[label]-buttonSpacing-[goodButton]-buttonSpacing-[averageButton]-buttonSpacing-[badButton]" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[label]-|" options:0 metrics:nil views:views]];
}

- (void)viewWillAppear:(BOOL)animated {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        dateFormatter.dateStyle = NSDateFormatterLongStyle;
    }
    [super viewWillAppear:animated];
    self.title = [dateFormatter stringFromDate:[NSDate date]];
    [self hd_updateDisplay];
}

- (void)hd_handleButtonTap:(UIButton*)button {
    [self.dataController setMood:button.tag ForDate:[NSDate date]];
    [self hd_updateDisplay];
}

#pragma mark - Private methods

- (void)hd_updateDisplay {
    HDMood recordedMood = [self.dataController moodForDate:[NSDate date]];
    for (UIButton *button in self.buttons) {
        button.selected = recordedMood == button.tag;
    }
}

@end
