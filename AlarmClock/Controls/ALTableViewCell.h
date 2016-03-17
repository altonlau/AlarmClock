//
//  ALTableViewCell.h
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-08.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import <SWTableViewCell/SWTableViewCell.h>

@interface ALTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIView *alarmView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
