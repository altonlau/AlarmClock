//
//  ALAlarm.h
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-05.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

typedef NS_ENUM(NSInteger, ALRepeatDays) {
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY,
    WEEKDAYS,
    WEEKENDS,
    EVERYDAY,
    NEVER,
};

@interface ALAlarm : NSObject

@property (strong, nonatomic) NSURL *id;
@property (strong, nonatomic) NSString *message;
@property (nonatomic) BOOL enabled;
@property (strong, nonatomic) NSMutableArray *repeat;
@property (strong, nonatomic) NSDate *time;

- (id)initWithId:(NSURL *)id enabled:(BOOL)enabled message:(NSString *)message repeat:(NSMutableArray *)repeat time:(NSDate *)time;

@end
