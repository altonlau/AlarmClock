//
//  ALAAMessageViewController.h
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-07.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import "ALAlarm.h"

@interface ALAAMessageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

- (id)initWithAlarm:(ALAlarm *)alarm;
- (IBAction)viewTapped:(id)sender;

@end
