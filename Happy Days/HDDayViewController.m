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

@interface HDDayViewController ()
@property (nonatomic) UIButton *goodButton;
@property (nonatomic) UIButton *averageButton;
@property (nonatomic) UIButton *badButton;
@property (nonatomic) NSArray *buttons;
@end

@implementation HDDayViewController

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hd_updateDisplay) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        // TODO: on significant time change we should check to see if the view is foremost; if so, show a dialog asking the user if they want to switch to the new date
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hd_updateDisplay) name:UIApplicationSignificantTimeChangeNotification object:nil];
    }
    return self;
}

- (void)loadView {
    UIView *rootView = [[UIView alloc] init];
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hd_setupSubviews];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"851-calendar"] style:UIBarButtonItemStylePlain target:self action:@selector(hd_handleYearButton:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hd_updateDisplay];
}

#pragma mark - Private methods

- (void)hd_handleButtonTap:(UIButton*)button {
    [self.dataController setMood:button.tag ForDate:[NSDate date]];
    
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
    self.title = [dateFormatter stringFromDate:[NSDate date]];

    HDMood recordedMood = [self.dataController moodForDate:[NSDate date]];
    for (UIButton *button in self.buttons) {
        button.selected = recordedMood == button.tag;
    }
}

- (void)hd_setupSubviews {
    
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.text = @"How was today?";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *goodButton = [[HDMoodButton alloc] init];
    goodButton.translatesAutoresizingMaskIntoConstraints = NO;
    goodButton.tag = HDMoodGood;
    goodButton.backgroundColor = [UIColor colorWithRed:0.780 green:0.941 blue:0.620 alpha:1.000];
    [goodButton setTitle:@"Good" forState:UIControlStateNormal];
    [goodButton addTarget:self action:@selector(hd_handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goodButton];
    
    UIButton *averageButton = [[HDMoodButton alloc] init];
    averageButton.translatesAutoresizingMaskIntoConstraints = NO;
    averageButton.tag = HDMoodAverage;
    averageButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.965 blue:0.678 alpha:1.000];
    [averageButton setTitle:@"Average" forState:UIControlStateNormal];
    [averageButton addTarget:self action:@selector(hd_handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:averageButton];
    
    UIButton *badButton = [[HDMoodButton alloc] init];
    badButton.translatesAutoresizingMaskIntoConstraints = NO;
    badButton.tag = HDMoodBad;
    badButton.backgroundColor = [UIColor colorWithRed:0.980 green:0.647 blue:0.616 alpha:1.000];
    [badButton setTitle:@"Bad" forState:UIControlStateNormal];
    [badButton addTarget:self action:@selector(hd_handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:badButton];
    
    id topGuide = self.topLayoutGuide;
    NSDictionary *views = NSDictionaryOfVariableBindings(topGuide, label, goodButton, averageButton, badButton);
    NSDictionary *metrics = @{ @"verticalSpacing": @20 };
    
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
