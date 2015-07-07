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

@property (weak, nonatomic) IBOutlet UIView *happyBirthdayBaseView;
@property (weak, nonatomic) IBOutlet UILabel *labelH;
@property (weak, nonatomic) IBOutlet UILabel *labelA;
@property (weak, nonatomic) IBOutlet UILabel *labelP;
@property (weak, nonatomic) IBOutlet UILabel *labelP2;
@property (weak, nonatomic) IBOutlet UILabel *labelY;
@property (weak, nonatomic) IBOutlet UILabel *labelB;
@property (weak, nonatomic) IBOutlet UILabel *labelI;
@property (weak, nonatomic) IBOutlet UILabel *labelR;
@property (weak, nonatomic) IBOutlet UILabel *labelT;
@property (weak, nonatomic) IBOutlet UILabel *labelH2;
@property (weak, nonatomic) IBOutlet UILabel *labelD;
@property (weak, nonatomic) IBOutlet UILabel *labelA2;
@property (weak, nonatomic) IBOutlet UILabel *labelY2;

@end

static NSArray* hbdColorCodes;

@implementation SplashView {
    NSArray* m_hbdLabelArrays;
}

- (SplashView*)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SplashView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        [self setBackgroundColor:[Utilities colorWithHex:0xfacade]];
        
        hbdColorCodes = @[ @0x20c014, @0xb90006, @0x186dfb, @0x7000bc, @0xf88709 ];
        
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
    
    m_hbdLabelArrays = @[ self.labelH, self.labelA, self.labelP, self.labelP2, self.labelY,
                          self.labelB, self.labelI, self.labelR, self.labelT, self.labelH2, self.labelD, self.labelA2, self.labelY2 ];
    
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
                        [self trinkleHappyBirthday];
                    }];
                }];
            }];
        }];
    }];
}

- (void)trinkleHappyBirthday {
    self.happyBirthdayBaseView.alpha = 0.0f;
    self.happyBirthdayBaseView.hidden = NO;
    [UIView animateWithDuration:0.25f animations:^{
        self.happyBirthdayBaseView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        UIViewAnimationOptions option = UIViewAnimationOptionTransitionCrossDissolve;
        CGFloat animationDuration = 0.5f;
        [UIView transitionWithView:self.happyBirthdayBaseView duration:animationDuration options:option animations:^{
            for (UILabel* label in m_hbdLabelArrays) {
                label.textColor = [Utilities colorWithHex:[self picRandomHbdColorCode]];
            }
        } completion:^(BOOL finished) {
            [UIView transitionWithView:self.happyBirthdayBaseView duration:animationDuration options:option animations:^{
                for (UILabel* label in m_hbdLabelArrays) {
                    label.textColor = [Utilities colorWithHex:[self picRandomHbdColorCode]];
                }
            } completion:^(BOOL finished) {
                [UIView transitionWithView:self.happyBirthdayBaseView duration:animationDuration options:option animations:^{
                    for (UILabel* label in m_hbdLabelArrays) {
                        label.textColor = [Utilities colorWithHex:[self picRandomHbdColorCode]];
                    }
                } completion:^(BOOL finished) {
                    [UIView transitionWithView:self.happyBirthdayBaseView duration:animationDuration options:option animations:^{
                        for (UILabel* label in m_hbdLabelArrays) {
                            label.textColor = [Utilities colorWithHex:[self picRandomHbdColorCode]];
                        }
                    } completion:^(BOOL finished) {
                        [UIView transitionWithView:self.happyBirthdayBaseView duration:animationDuration options:option animations:^{
                            for (UILabel* label in m_hbdLabelArrays) {
                                label.textColor = [Utilities colorWithHex:[self picRandomHbdColorCode]];
                            }
                        } completion:^(BOOL finished) {
                            [UIView transitionWithView:self.happyBirthdayBaseView duration:animationDuration options:option animations:^{
                                for (UILabel* label in m_hbdLabelArrays) {
                                    label.textColor = [Utilities colorWithHex:[self picRandomHbdColorCode]];
                                }
                            } completion:^(BOOL finished) {
                                [UIView transitionWithView:self.happyBirthdayBaseView duration:animationDuration options:option animations:^{
                                    UIColor* color = [Utilities colorWithHex:[hbdColorCodes[0] integerValue]];
                                    for (UILabel* label in m_hbdLabelArrays) {
                                        label.textColor = color;
                                    }
                                } completion:^(BOOL finished) {
                                    [UIView transitionWithView:self.happyBirthdayBaseView duration:animationDuration options:option animations:^{
                                        UIColor* color = [Utilities colorWithHex:[hbdColorCodes[1] integerValue]];
                                        for (UILabel* label in m_hbdLabelArrays) {
                                            label.textColor = color;
                                        }
                                    } completion:^(BOOL finished) {
                                        [UIView transitionWithView:self.happyBirthdayBaseView duration:animationDuration options:option animations:^{
                                            UIColor* color = [Utilities colorWithHex:[hbdColorCodes[2] integerValue]];
                                            for (UILabel* label in m_hbdLabelArrays) {
                                                label.textColor = color;
                                            }
                                        } completion:^(BOOL finished) {
                                            [UIView transitionWithView:self.happyBirthdayBaseView duration:animationDuration options:option animations:^{
                                                UIColor* color = [Utilities colorWithHex:[hbdColorCodes[3] integerValue]];
                                                for (UILabel* label in m_hbdLabelArrays) {
                                                    label.textColor = color;
                                                }
                                            } completion:^(BOOL finished) {
                                                [UIView transitionWithView:self.happyBirthdayBaseView duration:animationDuration options:option animations:^{
                                                    UIColor* color = [Utilities colorWithHex:[hbdColorCodes[4] integerValue]];
                                                    for (UILabel* label in m_hbdLabelArrays) {
                                                        label.textColor = color;
                                                    }
                                                } completion:^(BOOL finished) {
                                                    [UIView transitionWithView:self.happyBirthdayBaseView duration:animationDuration options:option animations:^{
                                                        for (UILabel* label in m_hbdLabelArrays) {
                                                            label.textColor = [UIColor whiteColor];
                                                        }
                                                    } completion:^(BOOL finished) {
                                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                            if (self.delegate && [self.delegate respondsToSelector:@selector(splashAnimationDidComplete)]) {
                                                                [self.delegate splashAnimationDidComplete];
                                                            }
                                                        });
                                                    }];
                                                }];
                                            }];
                                        }];
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

- (NSUInteger)picRandomHbdColorCode {
    return [[hbdColorCodes objectAtIndex:arc4random() % [hbdColorCodes count]] integerValue];
}

@end
