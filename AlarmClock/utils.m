//
//  utils.m
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-04.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import "utils.h"

#import <AVFoundation/AVFoundation.h>
#import "ALCoreDataHandler.h"

//------------------------------------------------------------------------
#pragma mark - GCD Helpers

void dispatch_to_bg(dispatch_block_t block) {
    dispatch_queue_t background_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(background_queue, block);
}

void dispatch_to_main(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), block);
}

dispatch_queue_t bg_queue_default(void) {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

id dispatch_later(NSTimeInterval delay, dispatch_block_t block) {
    __block BOOL cancelled = NO;
    void (^wrapper)(BOOL) = ^(BOOL cancel) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled) block();
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{wrapper(NO);});
    return [wrapper copy];
}

id dispatch_to_bg_later(NSTimeInterval delay, dispatch_block_t block) {
    __block BOOL cancelled = NO;
    void (^wrapper)(BOOL) = ^(BOOL cancel) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled) block();
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), bg_queue_default(), ^{wrapper(NO);});
    return [wrapper copy];
}

void cancel_dispatch(id block) {
    void (^wrapper)(BOOL) = block;
    wrapper(YES);
}


//------------------------------------------------------------------------
#pragma mark - Transformers

NSString* arrayToString(NSMutableArray *array) {
    NSString *string = @"";
    
    for (NSObject *object in array) {
        string = [string stringByAppendingFormat:@"%@, ", object];
    }
    
    return string.length > 2 ? [string substringToIndex:string.length - 2] : nil;
}

NSMutableArray* stringToArray(NSString *string) {
    return [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@", "]];
}

NSString* enumToString(NSInteger value) {
    return [kRepeatShortArray objectAtIndex:value];
}

NSInteger stringToEnum(NSString *string) {
    return [kRepeatShortArray indexOfObject:string];
}


//------------------------------------------------------------------------
#pragma mark - Alarm Handlers

NSDate* updateAlarmTime(ALAlarm *alarm) {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDateComponents *alarmDateComponents = [gregorian components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:alarm.time];
    NSDateComponents *currentDateComponents = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    
    [alarmDateComponents setYear:[currentDateComponents year]];
    [alarmDateComponents setMonth:[currentDateComponents month]];
    [alarmDateComponents setDay:[currentDateComponents day] + @(needsDateIncrement(alarm)).integerValue];
    [alarmDateComponents setWeekday:[currentDateComponents weekday] + @(needsDateIncrement(alarm)).integerValue];
    
    return [gregorian dateFromComponents:alarmDateComponents];
}

BOOL needsDateIncrement(ALAlarm *alarm) {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDateComponents *alarmDateComponents = [gregorian components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:alarm.time];
    NSDateComponents *currentDateComponents = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    
    if ([alarmDateComponents hour] < [currentDateComponents hour]) {
        return YES;
    } else if ([alarmDateComponents hour] == [currentDateComponents hour]) {
        if ([alarmDateComponents minute] < [currentDateComponents minute]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

BOOL shouldFireAlarm(ALAlarm *alarm) {
    if (!alarm.enabled) {
        return  NO;
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDateComponents *currentDateComponents = [gregorian components:(NSCalendarUnitWeekday) fromDate:[NSDate date]];
    
    NSInteger weekday = [currentDateComponents weekday] + @(needsDateIncrement(alarm)).integerValue - 2;
    if (weekday < 0) {
        weekday += 7;
    }
    
    if (alarm.repeat.count == 1) {
        if (stringToEnum(arrayToString(alarm.repeat)) == WEEKDAYS) {
            if (weekday == SATURDAY || weekday == SUNDAY) {
                return NO;
            }
        } else if (stringToEnum(arrayToString(alarm.repeat)) == WEEKENDS) {
            if (weekday != SATURDAY || weekday != SUNDAY) {
                return NO;
            }
        } else if (stringToEnum(arrayToString(alarm.repeat)) == EVERYDAY) {
            return YES;
        } else if (stringToEnum(arrayToString(alarm.repeat)) == NEVER) {
            return !needsDateIncrement(alarm);
        } else {
            if (stringToEnum(arrayToString(alarm.repeat)) != weekday) {
                return  NO;
            }
        }
    } else {
        if (![alarm.repeat containsObject:enumToString(weekday)]) {
            return NO;
        }
    }
    
    return YES;
}

NSArray* alarmsToFireToday() {
    NSMutableArray *alarms = [[ALCoreDataHandler new] getAlarms];
    NSMutableArray *alarmsForToday = [NSMutableArray new];
    
    for (ALAlarm *alarm in alarms) {
        if (shouldFireAlarm(alarm) && !needsDateIncrement(alarm)) {
            alarm.time = updateAlarmTime(alarm);
            [alarmsForToday addObject:alarm];
        }
    }
    
    return alarmsForToday;
}


//------------------------------------------------------------------------
#pragma mark - Misc

AVAudioPlayer *audioPlayer;

Float64 play_sound(NSString *file_name, int repeat) {
    NSString *name = [file_name stringByDeletingPathExtension];
    NSString *extension = [file_name pathExtension];
    NSURL *musicFile = [NSURL fileURLWithPath:[NSBundle.mainBundle pathForResource:name ofType:extension]];
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    audioPlayer.numberOfLoops = repeat;
    [audioPlayer play];
    
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:musicFile options:nil];
    CMTime audioDuration = audioAsset.duration;
    return CMTimeGetSeconds(audioDuration);
}

void stop_sound() {
    [audioPlayer stop];
}