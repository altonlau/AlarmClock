//
//  ALAlarmsViewController.m
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-04.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

// TODO: LOCAL NOTIFICATIONS!! THEY'RE ALL COMMENTED OUT!

#import "ALAlarmsViewController.h"

#import "ALAAViewController.h"
#import "ALAlarm.h"
#import "ALAppDelegate.h"
#import "ALCoreDataHandler.h"
#import "ALTableViewCell.h"
#import "UIColor+Theme.h"

@interface ALAlarmsViewController ()

//------------------------------------------------------------------------------
#pragma mark - Properties

@property (strong, nonatomic) NSMutableArray *alarms;
@property (strong, nonatomic) NSMutableArray *alarmsChanged;
@property (strong, nonatomic) NSMutableArray *alarmsDeleted;

@end

@implementation ALAlarmsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"applicationDidEnterBackground" object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.alarms = [[ALCoreDataHandler new] getAlarms];
    self.alarmsChanged = [NSMutableArray new];
    self.alarmsDeleted = [NSMutableArray new];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Actually clean up core data when the view disappears
    [self saveWithCompletion:^(NSError *error) {
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}


//------------------------------------------------------------------------------
#pragma mark - Setup Methods

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)];
}

- (void)setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"ALTableViewCell" bundle:nil] forCellReuseIdentifier:@"AlarmIdentifier"];
}


//------------------------------------------------------------------------------
#pragma mark - SWTableViewCellDelegate Methods

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    ALAlarm *alarm = [self.alarms objectAtIndex:cellIndexPath.row];
    
    switch (index) {
        case 0: {
            // Edit alarm
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[ALAAViewController alloc] initWithAlarm:alarm]];
            
            navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
            navigationController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
            navigationController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
            
            [self presentViewController:navigationController animated:YES completion:nil];
            break;
        }
        case 1: {
            [self.alarmsDeleted addObject:[self.alarms objectAtIndex:cellIndexPath.row]];
            [self.alarms removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default: break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    ALAlarm *alarm = [self.alarms objectAtIndex:[self.tableView indexPathForCell:cell].row];
    alarm.enabled = !alarm.enabled;
    [self.alarmsChanged addObject:alarm];
    
    UIImage *alarmImage = [UIImage imageNamed: alarm.enabled ? @"AlarmClock-green" : @"AlarmClock-gray"];
    UIImage *scaledImage = [UIImage imageWithCGImage:[alarmImage CGImage] scale:(alarmImage.scale * 10.0) orientation:alarmImage.imageOrientation];
    
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor] icon:scaledImage];
    
    cell.leftUtilityButtons = leftUtilityButtons;
}


//------------------------------------------------------------------------------
#pragma mark - UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ALTableViewCell *cell = (ALTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AlarmIdentifier"];
    
    if (cell == nil) {
        cell = [[ALTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlarmIdentifier"];
    }
    
    ALAlarm *alarm = [self.alarms objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"hh:mma"];
    
    cell.delegate = self;
    cell.messageLabel.text = alarm.message;
    cell.repeatLabel.text = arrayToString(alarm.repeat);
    cell.timeLabel.text = [dateFormatter stringFromDate:alarm.time];
    
    UIImage *alarmImage = [UIImage imageNamed: alarm.enabled ? @"AlarmClock-green" : @"AlarmClock-gray"];
    UIImage *scaledImage = [UIImage imageWithCGImage:[alarmImage CGImage] scale:(alarmImage.scale * 10.0) orientation:alarmImage.imageOrientation];
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor greenTurquoiseColor] title:@"Edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor: [UIColor redFlamingoColor] title:@"Delete"];
    
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor] icon:scaledImage];
    
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.leftUtilityButtons = leftUtilityButtons;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alarms.count;
}


//------------------------------------------------------------------------------
#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}


//------------------------------------------------------------------------------
#pragma mark - Public Methods

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


//------------------------------------------------------------------------------
#pragma mark - Private Methods

- (void)addButtonPressed:(id)sender {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[ALAAViewController new]];
    
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    navigationController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    navigationController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)saveWithCompletion:(ALCompletionBlock)completion {
    // Actually clean up core data when the view disappears
    for (ALAlarm *alarm in self.alarmsChanged) {
        [[ALCoreDataHandler new] insertAlarm:alarm withCompletion:^(NSError *error) {
            if (error) {
                NSLog(@"[ERROR] Unable to update alarm:\n           %@", error);
                completion(error);
                return;
            }
        }];
    }
    
    for (ALAlarm *alarm in self.alarmsDeleted) {
        [[ALCoreDataHandler new] deleteAlarm:alarm withCompletion:^(NSError *error) {
            if (error) {
                NSLog(@"[ERROR] Unable to delete alarm:\n           %@", error);
                completion(error);
                return;
            }
        }];
    }
    
    completion(nil);
}

//- (void)handleNotification:(NSNotification *)notification {
//    if ([[notification name] isEqualToString:@"applicationDidEnterBackground"]) {
//        [self saveWithCompletion:^(NSError *error) {
//            [self.navigationController popViewControllerAnimated:YES];
//            [(ALAppDelegate *)[[UIApplication sharedApplication] delegate] handleLocalNotifications];
//        }];
//    }
//}

@end
