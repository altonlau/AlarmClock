//
//  ALAAViewController.h
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-06.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import "ALAlarm.h"

@interface ALAAViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *repeatView;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;

- (id)initWithAlarm:(ALAlarm *)alarm;
- (IBAction)messageViewTapped:(id)sender;
- (IBAction)repeatViewTapped:(id)sender;

@end
