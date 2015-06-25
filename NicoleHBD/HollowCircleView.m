//
//  HollowCircleView.m
//  NicoleHBD
//
//  Created by bobiechen on 6/24/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import "HollowCircleView.h"

@implementation HollowCircleView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor( context, [self backgroundColor].CGColor );
    CGContextFillRect( context, rect );
    
    CGRect holeRectIntersection = CGRectIntersection( CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height), rect );
    
    if( CGRectIntersectsRect( holeRectIntersection, rect ) )
    {
        CGContextAddEllipseInRect(context, holeRectIntersection);
        CGContextClip(context);
        CGContextClearRect(context, holeRectIntersection);
        CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
        CGContextFillRect( context, holeRectIntersection);
    }
}

@end
