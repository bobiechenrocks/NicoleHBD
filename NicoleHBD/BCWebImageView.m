//
//  BCWebImageView.m
//  NicoleHBD
//
//  Created by bobiechen on 6/30/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import "BCWebImageView.h"

@interface BCWebImageView ()

@property (strong, nonatomic) UIActivityIndicatorView* loadingIndicator;

@end

@implementation BCWebImageView

- (BCWebImageView*)initWithFrame:(CGRect)frame andUrl:(NSString*)url {
    if (self = [super initWithFrame:frame]) {
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:self.loadingIndicator];
        [self startFetchingImage:url];
    }
    
    return self;
}

- (void)startFetchingImage:(NSString*)url {
    
}

@end
