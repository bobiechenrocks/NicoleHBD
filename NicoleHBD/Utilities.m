//
//  Utilities.m
//  NicoleHBD
//
//  Created by bobiechen on 6/24/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (UIColor*)colorWithHex:(NSUInteger)colorCode {
    return [Utilities colorWithHex:colorCode alpha:1.0f];
}

+ (UIColor*)colorWithHex:(NSUInteger)colorCode alpha:(CGFloat)alpha {
    NSUInteger red = colorCode >> 16;
    NSUInteger green = (colorCode >> 8) & 0xff;
    NSUInteger blue = colorCode & 0xff;
    
    return [UIColor colorWithRed:((float)red)/255.0f green:((float)green)/255.0f blue:((float)blue)/255.0f alpha:alpha];
}

@end
