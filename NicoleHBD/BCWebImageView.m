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
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0f];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            if (httpResponse.statusCode == 200) {
                UIImage* image = [[UIImage alloc] initWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = image;
                });
            }
        }
    }];
}

@end
