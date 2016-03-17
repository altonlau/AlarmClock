//
//  ALMainViewController.m
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-03.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

// TODO: LOCAL NOTIFICATIONS!! THEY'RE ALL COMMENTED OUT!

#import "ALMainViewController.h"

#import "ALAlarmsViewController.h"
#import "ALAppDelegate.h"
#import "ALCoreDataHandler.h"
#import "ALGTapViewController.h"

@interface ALMainViewController ()

//------------------------------------------------------------------------------
#pragma mark - Properties

@property (nonatomic, getter=shouldUpdateTime) BOOL updateTime;
@property (nonatomic, getter=shouldPollTime) BOOL pollTime;

@end

@implementation ALMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAlarmPoll];
    [self setupTimeLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"applicationDidEnterBackground" object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self setupAlarmPoll];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.pollTime = NO;
}


//------------------------------------------------------------------------------
#pragma mark - Setup Methods

- (void)setupAlarmPoll {
    NSArray *alarmsForToday = alarmsToFireToday();
    
    self.pollTime = alarmsForToday.count;
    
    [self pollTimeForAlarms:alarmsForToday interval:0.1];
}

- (void)setupTimeLabel {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    
    self.updateTime = YES;
    
    [self updateTimeWithFormat:dateFormatter interval:0.1];
}


//------------------------------------------------------------------------------
#pragma mark - Public Methods

- (IBAction)alarmButtonPressed:(id)sender {
    [self.navigationController pushViewController:[ALAlarmsViewController new] animated:YES];
}


//------------------------------------------------------------------------------
#pragma mark - Private Methods

- (void)updateTimeWithFormat:(NSDateFormatter *)dateFormatter interval:(NSTimeInterval)interval {
    self.timeLabel.text = [dateFormatter stringFromDate: [NSDate date]];
    
    if (self.shouldUpdateTime) {
        dispatch_later(interval, ^{
            [self updateTimeWithFormat:dateFormatter interval:interval];
        });
    }
}

- (void)pollTimeForAlarms:(NSArray *)alarms interval:(NSTimeInterval)interval {
    for (ALAlarm *alarm in alarms) {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        
        if ([[dateFormatter stringFromDate:alarm.time] isEqualToString:[dateFormatter stringFromDate:[NSDate date]]]) {
            self.pollTime = NO;
            [self startAlarmActivity:alarm];
            return;
        }
    }
    
    if (self.shouldPollTime) {
        dispatch_later(interval, ^{
            [self pollTimeForAlarms:alarms interval:interval];
        });
    }
}

- (void)startAlarmActivity:(ALAlarm *)alarm {
    ALGTapViewController *tapViewController = [ALGTapViewController new];
    [tapViewController setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [self presentViewController:tapViewController animated:YES completion:nil];
}

//- (void)handleNotification:(NSNotification *)notification {
//    if ([[notification name] isEqualToString:@"applicationDidEnterBackground"]) {
//        [(ALAppDelegate *)[[UIApplication sharedApplication] delegate] handleLocalNotifications];
//    }
//}

@end
