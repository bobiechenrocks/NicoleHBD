//
//  ZoomZoomPicView.m
//  NicoleHBD
//
//  Created by bobiechen on 7/3/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import "ZoomZoomPicView.h"
#import "Utilities.h"

@interface ZoomZoomPicView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIActivityIndicatorView* loadingIndicator;
@property (strong, nonatomic) UIImageView* picView;
@property (strong, nonatomic) UIButton* dismissButton;
@property (strong, nonatomic) UIButton* wordsButton;
@property (strong, nonatomic) UIScrollView* wishWordsScroll;
@property (strong, nonatomic) UILabel* wishWordsLabel;

@property (strong, nonatomic) NSString* wishWords;

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
        
//        self.dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 32.0f, 32.0f)];
//        [self addSubview:self.dismissButton];
//        [self.dismissButton setImage:[UIImage imageNamed:@"dismiss.png"] forState:UIControlStateNormal];
//        [self.dismissButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat y = self.frame.size.height - 15.0f - 32.0f;
        self.wordsButton = [[UIButton alloc] initWithFrame:CGRectMake(15.0f, y, 32.0f, 32.0f)];
        [self addSubview:self.wordsButton];
        [self.wordsButton setImage:[UIImage imageNamed:@"words.png"] forState:UIControlStateNormal];
        [self.wordsButton addTarget:self action:@selector(showWishWords) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)preparePicView:(NSString*)filename url:(NSString*)url wishWords:(NSString*)wishWords {
    self.wordsButton.hidden = ([wishWords length] > 0)? NO : YES;
    self.wishWords = wishWords;
    
    self.zoomScale = 1.0f;
    if (self.picView.image) {
        self.picView.image = nil;
    }
    
    if (!self.loadingIndicator) {
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:self.loadingIndicator];
    }
    
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
        self.wishWordsScroll.hidden = YES;
    }];
}

- (void)dismissView {
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.wishWordsScroll.hidden = YES;
    }];
}

- (void)showWishWords {
    if (!self.wishWordsScroll) {
        CGFloat height = 200.0f, width = self.frame.size.width - 32.0f - 40.0f;  // 15.0 margin on both sides
        CGFloat x = self.wordsButton.frame.origin.x + 32.0f + 15.0f, y = self.frame.size.height - height - 15.0f;
        self.wishWordsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self addSubview:self.wishWordsScroll];
        [self.wishWordsScroll setBackgroundColor:[Utilities colorWithHex:0x000000 alpha:0.5f]];
        [self.wishWordsScroll.layer setCornerRadius:5.0f];
        
        self.wishWordsScroll.hidden = YES;
    }
    [self addSubview:self.wishWordsScroll];
    
    if (self.wishWordsScroll.hidden) {
        self.wishWordsScroll.alpha = 0.0f;
        [self prepareWishWords];
        [UIView animateWithDuration:0.15f animations:^{
            self.wishWordsScroll.hidden = NO;
            self.wishWordsScroll.alpha = 10.0f;
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        self.wishWordsScroll.alpha = 1.0f;
        [UIView animateWithDuration:0.15f animations:^{
            self.wishWordsScroll.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.wishWordsScroll.hidden = YES;
        }];
    }
}

- (void)prepareWishWords {
    if (!self.wishWordsLabel) {
        self.wishWordsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.wishWordsScroll addSubview:self.wishWordsLabel];
        [self.wishWordsLabel setBackgroundColor:[UIColor clearColor]];
        [self.wishWordsLabel setNumberOfLines:0];
        [self.wishWordsLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.wishWordsLabel setTextColor:[UIColor whiteColor]];
    }
    
    [self.wishWordsLabel setText:self.wishWords];
    CGRect frame = self.wishWordsLabel.frame;
    CGFloat margin = 5.0f;
    frame.size.width = self.wishWordsScroll.frame.size.width - margin*2;
    frame.origin.x = frame.origin.y = margin;
    self.wishWordsLabel.frame = frame;
    
    [self.wishWordsLabel sizeToFit];
    
    CGFloat wishWordsScrollMaxHeight = 200.0f;
    CGFloat contentHeight = self.wishWordsLabel.frame.size.height + 2*margin;
    frame = self.wishWordsScroll.frame;
    frame.size.height = (contentHeight > wishWordsScrollMaxHeight)? wishWordsScrollMaxHeight : contentHeight;
    frame.origin.y = self.frame.size.height - frame.size.height - 15.0f;
    self.wishWordsScroll.frame = frame;
    
    [self.wishWordsScroll setContentSize:CGSizeMake(self.wishWordsScroll.frame.size.width, self.wishWordsLabel.frame.size.height + 2*margin)];
}

@end
