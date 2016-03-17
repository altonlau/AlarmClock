//
//  ALMainViewController.h
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-03.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

@interface ALMainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)alarmButtonPressed:(id)sender;

@end
