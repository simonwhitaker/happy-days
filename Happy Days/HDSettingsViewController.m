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
@property (nonatomic, weak) UISwitch *reminderSwitch;
@end

@implementation HDSettingsViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hd_handleDoneButton:)];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return HDSettingsSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == HDSettingsSectionReminder) {
        return self.notificationController.isLocalNotificationEnabled ? HDSettingsReminderRowsCount : HDSettingsReminderRowsCount - 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStandardCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kStandardCellId];
    }

    if (indexPath.section == HDSettingsSectionReminder) {
        if (indexPath.row == HDSettingsReminderRowOnSwitch) {
            cell.textLabel.text = @"Remind me each day";
            
            UISwitch *reminderSwitch = [[UISwitch alloc] init];
            reminderSwitch.on = self.notificationController.isLocalNotificationEnabled;
            self.reminderSwitch = reminderSwitch;
            [reminderSwitch addTarget:self action:@selector(hd_handleReminderSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = reminderSwitch;
            cell.detailTextLabel.text = nil;
        }
        else if (indexPath.row == HDSettingsReminderRowTime) {
            cell.textLabel.text = @"Reminder time";
            cell.accessoryView = nil;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu:%02lu", self.notificationController.timeMinutes / 60, self.notificationController.timeMinutes % 60];
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case HDSettingsSectionReminder:
            return @"Reminder";
        default:
            return nil;
    }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HDSettingsSectionReminder) {
        if (indexPath.row == HDSettingsReminderRowOnSwitch) {
            self.notificationController.localNotificationEnabled = !self.notificationController.isLocalNotificationEnabled;
            [self.reminderSwitch setOn:self.notificationController.isLocalNotificationEnabled animated:YES];
            [self hd_reloadReminderSection];
        }
    }
}

- (void)hd_handleDoneButton:(id)sender {
    [self.delegate viewControllerShouldDismiss:self wasCancelled:false];
}

- (void)hd_handleReminderSwitch:(UISwitch*)reminderSwitch {
    self.notificationController.localNotificationEnabled = reminderSwitch.isOn;
    [self hd_reloadReminderSection];
}

- (void)hd_reloadReminderSection {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:HDSettingsSectionReminder] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
