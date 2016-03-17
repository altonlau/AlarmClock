//
//  ALAAViewController.m
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-06.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import "ALAAViewController.h"

#import "ALAAMessageViewController.h"
#import "ALAARepeatViewController.h"
#import "ALCoreDataHandler.h"
#import "UIColor+Theme.h"

@interface ALAAViewController ()

//------------------------------------------------------------------------------
#pragma mark - Properties

@property (strong, nonatomic) ALAlarm *alarm;

@end

@implementation ALAAViewController

//------------------------------------------------------------------------------
#pragma mark - Init

- (id)initWithAlarm:(ALAlarm *)alarm {
    if (self = [super init]) {
        self.alarm = alarm;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    if (!self.alarm) {
        // Setting default values for a new alarm.
        NSString *message = @"Wake Up!";
        NSMutableArray *repeat = [[NSMutableArray alloc] initWithObjects:enumToString(NEVER), nil];
        NSDate *time = [[NSDate date] dateByAddingTimeInterval:3600];
        self.alarm = [[ALAlarm alloc] initWithId:nil enabled:YES message:message repeat:repeat time:time];
    } else {
        self.datePicker.date = self.alarm.time;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.messageLabel.text = self.alarm.message;
    self.repeatLabel.text = arrayToString(self.alarm.repeat);
}


//------------------------------------------------------------------------------
#pragma mark - Setup Methods

- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed:)];
}


//------------------------------------------------------------------------------
#pragma mark - Public Methods

- (IBAction)messageViewTapped:(id)sender {
    [self handleViewTapped:self.messageView];
}

- (IBAction)repeatViewTapped:(id)sender {
    [self handleViewTapped:self.repeatView];
}


//------------------------------------------------------------------------------
#pragma mark - Private Methods

- (void)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (void)saveButtonPressed:(id)sender {
    self.alarm.time = self.datePicker.date;
    
    [[ALCoreDataHandler new] insertAlarm:self.alarm withCompletion:^(NSError *error) {
        if (error) {
            NSLog(@"[ERROR] Unable to insert alarm:\n           %@", error);
        }
        
        [self dismissViewControllerAnimated:YES completion: nil];
    }];
}

- (void)handleViewTapped:(UIView *)view {
    view.backgroundColor = [UIColor greenTurquoiseColor];
    
    [self.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.5 animations:^{
        view.backgroundColor = UIColor.whiteColor;
    } completion:^(BOOL finished) {
        [self.view setUserInteractionEnabled:YES];
    }];
    
    if (view == self.messageView) {
        ALAAMessageViewController *addAlarmMessageViewController = [[ALAAMessageViewController alloc] initWithAlarm:self.alarm];
        [self.navigationController pushViewController:addAlarmMessageViewController animated:YES];
    } else if (view == self.repeatView) {
        ALAARepeatViewController *addAlarmRepeatViewController = [[ALAARepeatViewController alloc] initWithAlarm:self.alarm];
        [self.navigationController pushViewController:addAlarmRepeatViewController animated:YES];
    }
}

@end
