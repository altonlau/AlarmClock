//
//  ALAlarmsViewController.h
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-04.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import <SWTableViewCell/SWTableViewCell.h>

@interface ALAlarmsViewController : UIViewController
<SWTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)backButtonPressed:(id)sender;

@end
