//
//  Utilities.h
//  NicoleHBD
//
//  Created by bobiechen on 6/24/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

+ (UIColor*)colorWithHex:(NSUInteger)colorCode;
+ (UIColor*)colorWithHex:(NSUInteger)colorCode alpha:(CGFloat)alpha;

@end
