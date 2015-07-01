//
//  BypassTouchImageView.m
//  NicoleHBD
//
//  Created by bobiechen on 6/30/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import "BypassTouchImageView.h"

@implementation BypassTouchImageView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (hitView == self) {
        return nil;
    }
    
    return hitView;
}

@end
