//
//  ALAppDelegate.m
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-03.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

// TODO: LOCAL NOTIFICATIONS!! THEY'RE ALL COMMENTED OUT!

#import "ALAppDelegate.h"

#import "ALCoreDataHandler.h"
#import "ALMainViewController.h"
#import "UIColor+Theme.h"

@implementation ALAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
//        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
//    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[ALMainViewController new]];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = UIColor.greenTurquoiseColor;
    self.navigationController.navigationBarHidden = YES;
    
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground" object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[ALCoreDataHandler new] saveContext];
}


//------------------------------------------------------------------------------
#pragma mark - Private Methods

//- (void)handleLocalNotifications {
//    UILocalNotification *localNotification = [UILocalNotification new];
//    
//    NSMutableArray *alarms = [[ALCoreDataHandler new] getAlarms];
//    
//    for (ALAlarm *alarm in alarms) {
//        if (shouldFireAlarm(alarm)) {
//            localNotification.alertBody = alarm.message;
//            localNotification.fireDate = updateAlarmTime(alarm);
//            localNotification.soundName = @"Ferrari.m4a";
//            
//            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//        }
//    }
//}

@end
