//
//  ALAARepeatViewController.m
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-07.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import "ALAARepeatViewController.h"

#import "UIColor+Theme.h"

@interface ALAARepeatViewController ()

//------------------------------------------------------------------------------
#pragma mark - Properties

@property (strong, nonatomic) ALAlarm *alarm;
@property (strong, nonatomic) NSMutableArray *selectedArray;

@end

@implementation ALAARepeatViewController

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
    [self setupTableView];
}


//------------------------------------------------------------------------------
#pragma mark - Setup Methods

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
}

- (void)setupTableView {
    self.repeatTableView.dataSource = self;
    self.repeatTableView.delegate = self;
    
    self.selectedArray = [NSMutableArray array];
    
    for (NSString *string in self.alarm.repeat) {
        if (stringToEnum(string) == NEVER) {
            break;
        } else if (stringToEnum(string) == WEEKDAYS) {
            [self.selectedArray addObjectsFromArray:[NSArray arrayWithObjects:
                                                     enumToString(MONDAY),
                                                     enumToString(TUESDAY),
                                                     enumToString(WEDNESDAY),
                                                     enumToString(THURSDAY),
                                                     enumToString(FRIDAY),
                                                     nil]];
            break;
        } else if (stringToEnum(string) == WEEKENDS) {
            [self.selectedArray addObjectsFromArray:[NSArray arrayWithObjects:
                                                     enumToString(SATURDAY),
                                                     enumToString(SUNDAY),
                                                     nil]];
            break;
        } else if (stringToEnum(string) == EVERYDAY) {
            [self.selectedArray addObjectsFromArray:[NSArray arrayWithObjects:
                                                     enumToString(MONDAY),
                                                     enumToString(TUESDAY),
                                                     enumToString(WEDNESDAY),
                                                     enumToString(THURSDAY),
                                                     enumToString(FRIDAY),
                                                     enumToString(SATURDAY),
                                                     enumToString(SUNDAY),
                                                     nil]];
            break;
        } else {
            [self.selectedArray addObject:string];
        }
    }
}


//------------------------------------------------------------------------------
#pragma mark - UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepeatIdentifier"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RepeatIdentifier"];
    }
    
    cell.backgroundColor = [[UIColor greenTurquoiseColor] colorWithAlphaComponent:0];
    cell.textLabel.text = [kRepeatArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    if ([self.selectedArray containsObject:enumToString(indexPath.row)]) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
        cell.backgroundColor = [cell.backgroundColor colorWithAlphaComponent:0.2];
        cell.selected = YES;
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}


//------------------------------------------------------------------------------
#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    
    cell.backgroundColor = [cell.backgroundColor colorWithAlphaComponent:1];
    [UIView animateWithDuration:0.2 animations:^{
        cell.backgroundColor = [cell.backgroundColor colorWithAlphaComponent:0.2];
    }];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = nil;
    
    [UIView animateWithDuration:0.1 animations:^{
        cell.backgroundColor = [cell.backgroundColor colorWithAlphaComponent:0];
    }];
}


//------------------------------------------------------------------------------
#pragma mark - Private Methods

- (void)doneButtonPressed:(id)sender {
    NSArray *selectedArray = [[self.repeatTableView indexPathsForSelectedRows] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 row] == [obj2 row]) {
            return NSOrderedSame;
        } else if ([obj1 row]<[obj2 row]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    NSMutableArray *repeatArray = [NSMutableArray array];
    for (NSIndexPath *indexPath in selectedArray) {
        [repeatArray addObject:enumToString(indexPath.row)];
    }
    self.alarm.repeat = repeatArray;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
