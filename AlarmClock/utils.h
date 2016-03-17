//
//  utils.h
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-04.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import "ALAlarm.h"

/**
 * GCD Helpers
 **/

void dispatch_to_bg(dispatch_block_t block);
void dispatch_to_main(dispatch_block_t block);
dispatch_queue_t bg_queue_default(void);
id dispatch_later(NSTimeInterval delay, dispatch_block_t block);
id dispatch_to_bg_later(NSTimeInterval delay, dispatch_block_t block);
void cancel_dispatch(id block);

/**
 * Transformers
 **/

#define kRepeatArray @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", @"Weekdays", @"Weekends", @"Everyday", @"Never"]
#define kRepeatShortArray @[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun", @"Weekdays", @"Weekends", @"Everyday", @"Never"]
NSString* arrayToString(NSMutableArray *array);
NSMutableArray* stringToArray(NSString *string);
NSString* enumToString(NSInteger value);
NSInteger stringToEnum(NSString *string);

/**
 * Alarm Handlers
 **/

NSDate* updateAlarmTime(ALAlarm *alarm);
BOOL needsDateIncrement(ALAlarm *alarm);
BOOL shouldFireAlarm(ALAlarm *alarm);
NSArray* alarmsToFireToday();

/**
 * Misc
 **/

Float64 play_sound(NSString *file_name, int repeat);
void stop_sound();