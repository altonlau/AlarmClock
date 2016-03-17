//
//  UIColor+Theme.m
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-04.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import "UIColor+Theme.h"

@implementation UIColor (Theme)

+ (UIColor *)intColorWithRed: (NSUInteger)red green: (NSUInteger)green blue: (NSUInteger)blue alpha: (CGFloat)alpha {
    return [UIColor colorWithRed: red/255.0 green: green/255.0 blue: blue/255.0 alpha: alpha];
}

+ (UIColor *)colorWithHexString: (NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch (colorString.length) {
            // #RGB
        case 3: {
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        }
            // #ARGB
        case 4: {
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        }
            // #RRGGBB
        case 6: {
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        }
            // #AARRGGBB
        case 8: {
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        }
        default: {
            [NSException raise: @"Invalid color value" format: @"Color value %@ is invalid.  " "It should be a hex value of the form " "#RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
        }
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)colorComponentFrom: (NSString *)string start: (NSUInteger)start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring :
    [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)redFlamingoColor {
    return [self colorWithHexString:@"EF4836"];
}

+ (UIColor *)greenAquaIslandColor {
    return [self colorWithHexString:@"A2DED0"];
}

+ (UIColor *)greenLightSeaColor {
    return [self colorWithHexString:@"1BA39C"];
}

+ (UIColor *)greenTurquoiseColor {
    return [self colorWithHexString:@"4BD5B9"];
}

@end
