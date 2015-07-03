//
//  BCWebImageView.h
//  NicoleHBD
//
//  Created by bobiechen on 6/30/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCWebImageView : UIImageView

- (BCWebImageView*)initWithFrame:(CGRect)frame filename:(NSString*)filename url:(NSString*)url;

@end
