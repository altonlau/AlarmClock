//
//  ALAARepeatViewController.h
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-07.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import "ALAlarm.h"

@interface ALAARepeatViewController : UIViewController
    <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *repeatTableView;

- (id)initWithAlarm:(ALAlarm *)alarm;

@end
