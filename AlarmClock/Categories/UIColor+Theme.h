//
//  UIColor+Theme.h
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-04.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Theme)

+ (UIColor *)intColorWithRed: (NSUInteger)red
                       green: (NSUInteger)green
                        blue: (NSUInteger)blue
                       alpha: (CGFloat)alpha;
+ (UIColor *)colorWithHexString: (NSString *)hexString;

+ (UIColor *)redFlamingoColor;

+ (UIColor *)greenAquaIslandColor;
+ (UIColor *)greenLightSeaColor;
+ (UIColor *)greenTurquoiseColor;

@end
