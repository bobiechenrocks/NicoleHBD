//
//  SplashView.h
//  NicoleHBD
//
//  Created by bobiechen on 7/5/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SplashViewDelegate <NSObject>

- (void)splashAnimationDidComplete;

@end

@interface SplashView : UIView

@property (weak, nonatomic) id<SplashViewDelegate> delegate;

@end
