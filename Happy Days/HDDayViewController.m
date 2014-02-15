//
//  HDDayViewController.m
//  Happy Days
//
//  Created by Simon Whitaker on 19/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDDayViewController.h"
#import "HDSettingsViewController.h"
#import "HDYearViewController.h"
#import "HDMoodButton.h"
#import "NSDate+HDAdditions.h"
#import "UIColor+HDAdditions.h"

@interface HDDayViewController () <HDDismissableViewControllerDelegate>
@property (nonatomic) UIButton *goodButton;
@property (nonatomic) UIButton *averageButton;
@property (nonatomic) UIButton *badButton;
@property (nonatomic) UIButton *calendarButton;
@property (nonatomic) UIButton *settingsButton;
@property (nonatomic) NSArray *buttons;
@property (nonatomic) UILabel *titleLabel;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // If this is a day we've already recorded, we need the current selection to be visible
    [self hd_updateDisplay];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)setDate:(NSDate *)date {
    if (date != _date) {
        _date = date;
        [self hd_updateDisplay];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.goodButton.selected ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
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
    
    self.titleLabel.textColor = self.goodButton.selected ? [UIColor whiteColor] : [UIColor darkGrayColor];
    self.calendarButton.tintColor = self.badButton.selected ? [UIColor whiteColor] : [UIColor darkGrayColor];
    self.settingsButton.tintColor = self.badButton.selected ? [UIColor whiteColor] : [UIColor darkGrayColor];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void)hd_setupSubviews {
    
    UIColor *normalButtonBackgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    UIColor *normalButtonTitleColor = [UIColor darkGrayColor];
    UIColor *selectedButtonTitleColor = [UIColor whiteColor];
    
    HDMoodButton *goodButton = [[HDMoodButton alloc] init];
    goodButton.translatesAutoresizingMaskIntoConstraints = NO;
    goodButton.tag = HDMoodGood;
    [goodButton setTitleColor:normalButtonTitleColor forState:UIControlStateNormal];
    [goodButton setBackgroundColor:normalButtonBackgroundColor forState:UIControlStateNormal];
    [goodButton setTitleColor:selectedButtonTitleColor forState:UIControlStateSelected];
    [goodButton setBackgroundColor:[UIColor hd_goodBackgroundColor] forState:UIControlStateSelected];
    [goodButton setTitle:@"Good" forState:UIControlStateNormal];
    [goodButton addTarget:self action:@selector(hd_handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goodButton];
    self.goodButton = goodButton;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:goodButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:goodButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:goodButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.33 constant:0.0]];
    
    HDMoodButton *averageButton = [[HDMoodButton alloc] init];
    averageButton.translatesAutoresizingMaskIntoConstraints = NO;
    averageButton.tag = HDMoodAverage;
    [averageButton setTitleColor:normalButtonTitleColor forState:UIControlStateNormal];
    [averageButton setBackgroundColor:normalButtonBackgroundColor forState:UIControlStateNormal];
    [averageButton setTitleColor:selectedButtonTitleColor forState:UIControlStateSelected];
    [averageButton setBackgroundColor:[UIColor hd_averageBackgroundColor] forState:UIControlStateSelected];
    [averageButton setTitle:@"Average" forState:UIControlStateNormal];
    [averageButton addTarget:self action:@selector(hd_handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:averageButton];
    self.averageButton = averageButton;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:averageButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:averageButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:averageButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.33 constant:0.0]];
    
    HDMoodButton *badButton = [[HDMoodButton alloc] init];
    badButton.translatesAutoresizingMaskIntoConstraints = NO;
    badButton.tag = HDMoodBad;
    [badButton setTitleColor:normalButtonTitleColor forState:UIControlStateNormal];
    [badButton setBackgroundColor:normalButtonBackgroundColor forState:UIControlStateNormal];
    [badButton setTitleColor:selectedButtonTitleColor forState:UIControlStateSelected];
    [badButton setBackgroundColor:[UIColor hd_badBackgroundColor] forState:UIControlStateSelected];
    [badButton setTitle:@"Bad" forState:UIControlStateNormal];
    [badButton addTarget:self action:@selector(hd_handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:badButton];
    self.badButton = badButton;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:badButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:badButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];

    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
    label.textColor = [UIColor whiteColor];
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
    self.titleLabel = label;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0]];
    
    id topGuide = self.topLayoutGuide;
    NSDictionary *views = NSDictionaryOfVariableBindings(topGuide, label, goodButton, averageButton, badButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[goodButton][averageButton][badButton]|" options:0 metrics:nil views:views]];
    
    self.buttons = @[ goodButton, averageButton, badButton ];
    
    UIButton *calendarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    calendarButton.translatesAutoresizingMaskIntoConstraints = NO;
    [calendarButton setImage:[[UIImage imageNamed:@"851-calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [calendarButton addTarget:self action:@selector(hd_handleYearButton:) forControlEvents:UIControlEventTouchUpInside];
    calendarButton.tintColor = [UIColor whiteColor];
    [self.view addSubview:calendarButton];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:calendarButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:calendarButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0-self.badButton.contentEdgeInsets.bottom]];
    self.calendarButton = calendarButton;

    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [settingsButton setImage:[[UIImage imageNamed:@"740-gear"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(hd_handleSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
    settingsButton.tintColor = [UIColor whiteColor];
    [self.view addSubview:settingsButton];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:settingsButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:calendarButton attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:settingsButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0-self.badButton.contentEdgeInsets.bottom]];
    self.settingsButton = settingsButton;
}

- (void)hd_handleYearButton:(id)sender {
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        HDYearViewController *yearVC = [[HDYearViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
        yearVC.year = dateComps.year;
        yearVC.dataController = self.dataController;
        
        [self.navigationController pushViewController:yearVC animated:YES];
    }
}

- (void)hd_handleSettingsButton:(id)sender {
    HDSettingsViewController *vc = [[HDSettingsViewController alloc] init];
    vc.notificationController = self.notificationController;
    vc.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - HDDismissableViewControllerDelegate methods

- (void)viewControllerShouldDismiss:(UIViewController *)viewController wasCancelled:(bool)wasCancelled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
