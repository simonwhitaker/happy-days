//
//  HDDayViewController.m
//  Happy Days
//
//  Created by Simon Whitaker on 19/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDDayViewController.h"
#import "HDYearViewController.h"
#import "HDMoodButton.h"
#import "NSDate+HDAdditions.h"

@interface HDDayViewController ()
@property (nonatomic) UIButton *goodButton;
@property (nonatomic) UIButton *averageButton;
@property (nonatomic) UIButton *badButton;
@property (nonatomic) NSArray *buttons;
@end

@implementation HDDayViewController

- (void)loadView {
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hd_setupSubviews];

    if (self == [self.navigationController.viewControllers firstObject]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"851-calendar"] style:UIBarButtonItemStylePlain target:self action:@selector(hd_handleYearButton:)];
    }
}

- (void)setDate:(NSDate *)date {
    if (date != _date) {
        _date = date;
        [self hd_updateDisplay];
    }
}

#pragma mark - Private methods

- (void)hd_handleButtonTap:(UIButton*)button {
    [self.dataController setMood:button.tag ForDate:self.date];
    
    // Now that they've given feedback for today, don't post a notification until tomorrow (if it's still due today)
    [self.notificationController postponeUntilTomorrow];
    [self hd_updateDisplay];
}

- (void)hd_updateDisplay {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        dateFormatter.dateStyle = NSDateFormatterLongStyle;
    }
    self.title = [dateFormatter stringFromDate:self.date];

    HDMood recordedMood = [self.dataController moodForDate:self.date];
    for (UIButton *button in self.buttons) {
        button.selected = recordedMood == button.tag;
    }
}

- (void)hd_setupSubviews {
    
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
    NSString *dayString;
    if ([self.date hd_isToday]) {
        dayString = @"today";
    }
    else {
        dayString = @"this day";
    }
    label.text = [NSString stringWithFormat:@"How was %@?", dayString];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIColor *normalButtonBackgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    UIColor *normalButtonTitleColor = [UIColor darkGrayColor];
    UIColor *selectedButtonTitleColor = [UIColor whiteColor];
    
    HDMoodButton *goodButton = [[HDMoodButton alloc] init];
    goodButton.translatesAutoresizingMaskIntoConstraints = NO;
    goodButton.tag = HDMoodGood;
    [goodButton setTitleColor:normalButtonTitleColor forState:UIControlStateNormal];
    [goodButton setBackgroundColor:normalButtonBackgroundColor forState:UIControlStateNormal];
    [goodButton setTitleColor:selectedButtonTitleColor forState:UIControlStateSelected];
    [goodButton setBackgroundColor:[UIColor colorWithRed:0.494 green:0.827 blue:0.129 alpha:1.000] forState:UIControlStateSelected];
    [goodButton setTitle:@"Good" forState:UIControlStateNormal];
    [goodButton addTarget:self action:@selector(hd_handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goodButton];
    
    HDMoodButton *averageButton = [[HDMoodButton alloc] init];
    averageButton.translatesAutoresizingMaskIntoConstraints = NO;
    averageButton.tag = HDMoodAverage;
    [averageButton setTitleColor:normalButtonTitleColor forState:UIControlStateNormal];
    [averageButton setBackgroundColor:normalButtonBackgroundColor forState:UIControlStateNormal];
    [averageButton setTitleColor:selectedButtonTitleColor forState:UIControlStateSelected];
    [averageButton setBackgroundColor:[UIColor colorWithRed:0.961 green:0.651 blue:0.137 alpha:1.000] forState:UIControlStateSelected];
    [averageButton setTitle:@"Average" forState:UIControlStateNormal];
    [averageButton addTarget:self action:@selector(hd_handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:averageButton];
    
    HDMoodButton *badButton = [[HDMoodButton alloc] init];
    badButton.translatesAutoresizingMaskIntoConstraints = NO;
    badButton.tag = HDMoodBad;
    [badButton setTitleColor:normalButtonTitleColor forState:UIControlStateNormal];
    [badButton setBackgroundColor:normalButtonBackgroundColor forState:UIControlStateNormal];
    [badButton setTitleColor:selectedButtonTitleColor forState:UIControlStateSelected];
    [badButton setBackgroundColor:[UIColor colorWithRed:0.816 green:0.008 blue:0.106 alpha:1.000] forState:UIControlStateSelected];
    [badButton setTitle:@"Bad" forState:UIControlStateNormal];
    [badButton addTarget:self action:@selector(hd_handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:badButton];
    
    id topGuide = self.topLayoutGuide;
    NSDictionary *views = NSDictionaryOfVariableBindings(topGuide, label, goodButton, averageButton, badButton);
    NSDictionary *metrics = @{ @"verticalSpacing": @40 };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-verticalSpacing-[label]-verticalSpacing-[goodButton]-verticalSpacing-[averageButton]-verticalSpacing-[badButton]" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[label]-|" options:0 metrics:nil views:views]];
    
    self.buttons = @[ goodButton, averageButton, badButton ];
}

- (void)hd_handleYearButton:(id)sender {
    HDYearViewController *yearVC = [[HDYearViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    yearVC.year = dateComps.year;
    yearVC.dataController = self.dataController;
    
    [self.navigationController pushViewController:yearVC animated:YES];
}

@end
