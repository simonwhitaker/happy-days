//
//  HDSettingsViewController.m
//  Happy Days
//
//  Created by Simon Whitaker on 08/02/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import "HDSettingsViewController.h"
#import "HDDatePickerCell.h"
#import "HDNotificationController+TimeAsDate.h"

static NSString *const kStandardCellId = @"StandardCellId";
static NSString *const kTimePickerCellId = @"TimePickerCellId";

typedef NS_ENUM(NSInteger, HDSettingsSection) {
    HDSettingsSectionReminder,

    HDSettingsSectionsCount
};

typedef NS_ENUM(NSInteger, HDSettingsReminderRow) {
    HDSettingsReminderRowOnSwitch,
    HDSettingsReminderRowTime,
    HDSettingsReminderRowTimePicker,
    
    HDSettingsReminderRowsCount
};

@interface HDSettingsViewController ()
@property (nonatomic, weak) UISwitch *reminderSwitch;
@property (nonatomic) bool showTimePicker;
@end

@implementation HDSettingsViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self.tableView registerClass:[HDDatePickerCell class] forCellReuseIdentifier:kTimePickerCellId];
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
        if (self.notificationController.isLocalNotificationEnabled && self.showTimePicker) {
            return 3;
        }
        else if (self.notificationController.isLocalNotificationEnabled) {
            return 2;
        }
        else {
            return 1;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.section == HDSettingsSectionReminder && indexPath.row == HDSettingsReminderRowTimePicker) {
        cell = [tableView dequeueReusableCellWithIdentifier:kTimePickerCellId forIndexPath:indexPath];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:kStandardCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kStandardCellId];
        }
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
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu:%02lu", (unsigned long)(self.notificationController.timeMinutes / 60), (unsigned long)(self.notificationController.timeMinutes % 60)];
        }
        else if (indexPath.row == HDSettingsReminderRowTimePicker) {
            HDDatePickerCell *datePickerCell = (HDDatePickerCell*)cell;
            datePickerCell.datePicker.datePickerMode = UIDatePickerModeTime;
            datePickerCell.datePicker.minuteInterval = 5;
            [datePickerCell.datePicker setDate:self.notificationController.notificationTimeAsDate animated:NO];
            [datePickerCell.datePicker addTarget:self action:@selector(hd_handleDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HDSettingsSectionReminder && indexPath.row == HDSettingsReminderRowTimePicker) {
        return 215.0;
    }
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HDSettingsSectionReminder) {
        if (indexPath.row == HDSettingsReminderRowTime) {
            self.showTimePicker = !self.showTimePicker;
            NSIndexPath *ip = [NSIndexPath indexPathForRow:HDSettingsReminderRowTimePicker inSection:HDSettingsSectionReminder];
            if (self.showTimePicker) {
                [tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationTop];
            }
            else {
                [tableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)hd_handleDoneButton:(id)sender {
    [self.delegate viewControllerShouldDismiss:self wasCancelled:false];
}

- (void)hd_handleReminderSwitch:(UISwitch*)reminderSwitch {
    self.notificationController.localNotificationEnabled = reminderSwitch.isOn;
}

- (void)hd_handleDatePickerValueChanged:(UIDatePicker*)datePicker {
    self.notificationController.notificationTimeAsDate = datePicker.date;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:HDSettingsReminderRowTime inSection:HDSettingsSectionReminder]] withRowAnimation:UITableViewRowAnimationNone];
}

@end
