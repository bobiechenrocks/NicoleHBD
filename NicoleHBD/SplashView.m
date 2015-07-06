//
//  SplashView.m
//  NicoleHBD
//
//  Created by bobiechen on 7/5/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashView.h"
#import "Utilities.h"

@interface SplashView ()

@property (strong, nonatomic) UILabel* seven;
@property (strong, nonatomic) UILabel* eight;

@end

@implementation SplashView

- (SplashView*)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[Utilities colorWithHex:0xfacade]];
        [self preparePostSplashView];
    }
    
    return self;
}

- (void)preparePostSplashView {
    CGFloat circle1size = 290.0f, circle2size = 275.0f, circleAutoLayoutOffset = 20.0f;;
    CGFloat circle1x = (self.frame.size.width - circle1size)/2.0f, circle1y = (self.frame.size.height - circle1size)/2.0f - circleAutoLayoutOffset;
    UIView* circle1 = [[UIView alloc] initWithFrame:CGRectMake(circle1x, circle1y, circle1size, circle1size)];
    [self addSubview:circle1];
    [circle1 setBackgroundColor:[UIColor clearColor]];
    [circle1.layer setCornerRadius:circle1size/2.0f];
    [circle1.layer setBorderColor:[UIColor whiteColor].CGColor];
    [circle1.layer setBorderWidth:5.0f];
    
    CGFloat circle2x = (self.frame.size.width - circle2size)/2.0f, circle2y = (self.frame.size.height - circle2size)/2.0f - circleAutoLayoutOffset;
    UIView* circle2 = [[UIView alloc] initWithFrame:CGRectMake(circle2x, circle2y, circle2size, circle2size)];
    [self addSubview:circle2];
    [circle2 setBackgroundColor:[UIColor clearColor]];
    circle2.clipsToBounds = YES;
    [circle2.layer setCornerRadius:circle2size/2.0f];
    [circle2.layer setBorderColor:[UIColor whiteColor].CGColor];
    [circle2.layer setBorderWidth:7.0f];
    
    UILabel* twenty = [[UILabel alloc] initWithFrame:CGRectZero];
    [circle2 addSubview:twenty];
    [twenty setBackgroundColor:[UIColor clearColor]];
    [twenty setFont:[UIFont fontWithName:@"Copperplate-Bold" size:180.0f]];
    [twenty setTextColor:[UIColor whiteColor]];
    twenty.text = @"2";
    [twenty sizeToFit];
    
    CGFloat marginFromCenter = 0.0f;
    CGRect frame = twenty.frame;
    frame.origin.x = circle2size/2.0f - frame.size.width - marginFromCenter;
    frame.origin.y = (circle2size - frame.size.height)/2.0f;
    twenty.frame = frame;
    
    /* 7 */
    self.seven = [[UILabel alloc] initWithFrame:CGRectZero];
    [circle2 addSubview:self.seven];
    [self.seven setBackgroundColor:[UIColor clearColor]];
    [self.seven setFont:[UIFont fontWithName:@"Copperplate-Bold" size:180.0f]];
    [self.seven setTextColor:[UIColor whiteColor]];
    self.seven.text = @"7";
    [self.seven sizeToFit];
    
    frame = self.seven.frame;
    frame.origin.x = circle2size/2.0f + marginFromCenter;
    frame.origin.y = (circle2size - frame.size.height)/2.0f;
    self.seven.frame = frame;
    
    /* 8 */
    self.eight = [[UILabel alloc] initWithFrame:CGRectZero];
    [circle2 addSubview:self.eight];
    [self.eight setBackgroundColor:[UIColor clearColor]];
    [self.eight setFont:[UIFont fontWithName:@"Copperplate-Bold" size:180.0f]];
    [self.eight setTextColor:[UIColor whiteColor]];
    self.eight.text = @"8";
    [self.eight sizeToFit];
    
    frame = self.eight.frame;
    frame.origin.x = circle2size/2.0f + marginFromCenter;
    frame.origin.y = -frame.size.height;//(circle2size - frame.size.height)/2.0f;
    self.eight.frame = frame;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dropEight];
    });
}

- (void)dropEight {
    CGFloat bias = 85.0f;
    [UIView animateWithDuration:0.1f animations:^{
        CGRect frame = self.eight.frame;
        frame.origin.y = self.seven.frame.origin.y - frame.size.height + bias;
        self.eight.frame = frame;
    } completion:^(BOOL finished) {
        CGFloat destinationYeight = self.seven.frame.origin.y + 10.0f;
        CGFloat destinationYseven = self.seven.frame.origin.y + self.seven.frame.size.height;
        [UIView animateWithDuration:0.1f animations:^{
            CGRect frame = self.eight.frame;
            frame.origin.y = destinationYeight;
            self.eight.frame = frame;
            
            CGRect frame2 = self.seven.frame;
            frame2.origin.y = destinationYseven;
            self.seven.frame = frame2;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f animations:^{
                CGRect frame = self.eight.frame;
                frame.origin.y = frame.origin.y - 13.0f;
                self.eight.frame = frame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    CGRect frame = self.eight.frame;
                    frame.origin.y = frame.origin.y + 5.0f;
                    self.eight.frame = frame;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        CGRect frame = self.eight.frame;
                        frame.origin.y = frame.origin.y - 2.0f;
                        self.eight.frame = frame;
                    } completion:^(BOOL finished) {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(splashAnimationDidComplete)]) {
                            [self.delegate splashAnimationDidComplete];
                        }
                    }];
                }];
            }];
        }];
    }];
}

@end
