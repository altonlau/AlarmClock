//
//  ALAlarm.m
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-05.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import "ALAlarm.h"

@implementation ALAlarm

@synthesize id = _id;
@synthesize message = _message;
@synthesize enabled = _enabled;
@synthesize repeat = _repeat;
@synthesize time = _time;

//------------------------------------------------------------------------------
#pragma mark - Implementation

- (id)initWithId:(NSURL *)id enabled:(BOOL)enabled  message:(NSString *)message repeat:(NSMutableArray *)repeat time:(NSDate *)time {
    if (self = [super init]) {
        _id = id;
        _message = message;
        _enabled = enabled;
        _repeat = repeat;
        _time = time;
    }
    
    return self;
}

- (NSURL *)id {
    return _id;
}

- (void)setId:(NSURL *)id {
    _id = id;
}

- (NSString *)message {
    return _message;
}

- (void)setMessage:(NSString *)message {
    _message = message;
}

- (NSMutableArray *)repeat {
    return _repeat;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
}

- (BOOL)enabled {
    return _enabled;
}

- (void)setRepeat:(NSMutableArray *)repeat {
    if ([repeat containsObject:enumToString(MONDAY)] &&
        [repeat containsObject:enumToString(TUESDAY)] &&
        [repeat containsObject:enumToString(WEDNESDAY)] &&
        [repeat containsObject:enumToString(THURSDAY)] &&
        [repeat containsObject:enumToString(FRIDAY)] &&
        [repeat containsObject:enumToString(SATURDAY)] &&
        [repeat containsObject:enumToString(SUNDAY)]) {
        _repeat = [NSMutableArray arrayWithObject:enumToString(EVERYDAY)];
    } else if ([repeat containsObject:enumToString(MONDAY)] &&
               [repeat containsObject:enumToString(TUESDAY)] &&
               [repeat containsObject:enumToString(WEDNESDAY)] &&
               [repeat containsObject:enumToString(THURSDAY)] &&
               [repeat containsObject:enumToString(FRIDAY)] &&
               ![repeat containsObject:enumToString(SATURDAY)] &&
               ![repeat containsObject:enumToString(SUNDAY)]) {
        _repeat = [NSMutableArray arrayWithObject:enumToString(WEEKDAYS)];
    } else if (![repeat containsObject:enumToString(MONDAY)] &&
               ![repeat containsObject:enumToString(TUESDAY)] &&
               ![repeat containsObject:enumToString(WEDNESDAY)] &&
               ![repeat containsObject:enumToString(THURSDAY)] &&
               ![repeat containsObject:enumToString(FRIDAY)] &&
               [repeat containsObject:enumToString(SATURDAY)] &&
               [repeat containsObject:enumToString(SUNDAY)]) {
        _repeat = [NSMutableArray arrayWithObject:enumToString(WEEKENDS)];
    } else if (repeat.count == 0) {
        _repeat = [NSMutableArray arrayWithObject:enumToString(NEVER)];
    } else {
        _repeat = repeat;
    }
}

- (NSDate *)time {
    return _time;
}

- (void)setTime:(NSDate *)time {
    _time = time;
}

@end
