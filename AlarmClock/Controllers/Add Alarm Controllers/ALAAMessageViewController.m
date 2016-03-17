//
//  ALAAMessageViewController.m
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-07.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import "ALAAMessageViewController.h"

@interface ALAAMessageViewController ()

@property (strong, nonatomic) ALAlarm *alarm;

@end

@implementation ALAAMessageViewController

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
    [self setupTextField];
}


//------------------------------------------------------------------------------
#pragma mark - Setup Methods

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
}

- (void)setupTextField {
    self.messageTextField.text = self.alarm.message;
}


//------------------------------------------------------------------------------
#pragma mark - Private Methods

- (void)doneButtonPressed:(id)sender {
    self.alarm.message = self.messageTextField.text;
    [self.messageTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)viewTapped:(id)sender {
    [self.messageTextField resignFirstResponder];
}

@end
