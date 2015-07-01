//
//  HollowCircleView.m
//  NicoleHBD
//
//  Created by bobiechen on 6/24/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import "HollowCircleView.h"
#import "Utilities.h"

@implementation HollowCircleView

- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor( context, [self backgroundColor].CGColor );
//    CGContextFillRect( context, rect );
//    
//    CGRect holeRectIntersection = CGRectIntersection( CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height), rect );
//    
//    if( CGRectIntersectsRect( holeRectIntersection, rect ) )
//    {
//        CGContextAddEllipseInRect(context, holeRectIntersection);
//        CGContextClip(context);
//        CGContextClearRect(context, holeRectIntersection);
//        CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
//        CGContextSetBlendMode(context, kCGBlendModeClear);
//        CGContextFillRect( context, holeRectIntersection);
//    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    CGRect rrect = self.bounds;
    
    CGFloat radius = 30.0f;//self.frame.size.width/2.0f;
    CGFloat width = CGRectGetWidth(rrect);
    CGFloat height = CGRectGetHeight(rrect);
    
    // Make sure corner radius isn't larger than half the shorter side
    if (radius > width/2.0)
        radius = width/2.0;
    if (radius > height/2.0)
        radius = height/2.0;
    
    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat midy = CGRectGetMidY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
