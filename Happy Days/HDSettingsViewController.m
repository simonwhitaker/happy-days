//
//  HDSettingsViewController.m
//  Happy Days
//
//  Created by Simon Whitaker on 08/02/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDSettingsViewController.h"

static NSString *const kStandardCellId = @"CellId";

typedef NS_ENUM(NSInteger, HDSettingsSection) {
    HDSettingsSectionReminder,

    HDSettingsSectionsCount
};

typedef NS_ENUM(NSInteger, HDSettingsReminderRow) {
    HDSettingsReminderRowOnSwitch,
    HDSettingsReminderRowTime,
    
    HDSettingsReminderRowsCount
};

@interface HDSettingsViewController ()

@end

@implementation HDSettingsViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kStandardCellId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hd_handleDoneButton:)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return HDSettingsSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == HDSettingsSectionReminder) {
        return self.notificationController.isLocalNotificationEnabled ? HDSettingsReminderRowsCount : HDSettingsReminderRowsCount - 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStandardCellId forIndexPath:indexPath];

    cell.textLabel.text = @"Cell here";
    
    return cell;
}

- (void)hd_handleDoneButton:(id)sender {
    [self.delegate viewControllerShouldDismiss:self wasCancelled:false];
}

@end
