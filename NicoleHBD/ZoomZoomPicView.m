//
//  ZoomZoomPicView.m
//  NicoleHBD
//
//  Created by bobiechen on 7/3/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import "ZoomZoomPicView.h"

@interface ZoomZoomPicView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIActivityIndicatorView* loadingIndicator;
@property (strong, nonatomic) UIImageView* picView;

@end


@implementation ZoomZoomPicView

- (ZoomZoomPicView*)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 3.0f;
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:singleTap];
    }
    
    return self;
}

- (void)preparePicView:(NSString*)filename url:(NSString*)url {
    self.zoomScale = 1.0f;
    self.picView.image = nil;
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:self.loadingIndicator];
    
    BOOL bPicNotReady = NO;
    if ([filename length] > 0) {
        UIImage* image = [UIImage imageNamed:filename];
        if (!image) {
            bPicNotReady = YES;
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateImage:image];
            });
        }
    }
    
    if (bPicNotReady && [url length] > 0) {
        [self startFetchingImage:url];
    }
}

- (void)startFetchingImage:(NSString*)url {
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0f];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.loadingIndicator.hidden = YES;
        if (!connectionError) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            if (httpResponse.statusCode == 200) {
                UIImage* image = [[UIImage alloc] initWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateImage:image];
                });
            }
        }
    }];
}

- (void)updateImage:(UIImage*)image {
    self.loadingIndicator.hidden = YES;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenWHRatio = screenSize.width / screenSize.height;
    CGFloat imageWHRatio = image.size.width / image.size.height;
    
    CGFloat width, height, x, y;
    if (imageWHRatio > screenWHRatio) {
        width = screenSize.width;
        height = width / imageWHRatio;
        x = 0.0f;
        y = (screenSize.height - height)/2.0f;
    }
    else {
        height = screenSize.height;
        width = height * imageWHRatio;
        y = 0.0f;
        x = (screenSize.width - width)/2.0f;
    }
    
    self.picView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self addSubview:self.picView];
    self.picView.image = image;
    [self.picView setUserInteractionEnabled:YES];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.picView;
}

- (void)handleTap:(UIGestureRecognizer*)recognizer {
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

@end
