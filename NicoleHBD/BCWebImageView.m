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

@implementation BCWebImageView {
    NSString* m_filenameToSave;
}

- (BCWebImageView*)initWithFrame:(CGRect)frame filename:(NSString *)filename url:(NSString *)url {
    if (self = [super initWithFrame:frame]) {
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:self.loadingIndicator];

        BOOL bPicNotReady = NO;
        if ([filename length] > 0) {
            UIImage* image = [UIImage imageNamed:filename];
            if (!image) {
                /* try searching the Document folder. maybe this image was fetched from internet */
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString* path = [documentsDirectory stringByAppendingPathComponent:filename];
                image = [UIImage imageWithContentsOfFile:path];
                if (!image) {
                    bPicNotReady = YES;
                }
                else {
                    self.image = image;
                }
            }
            else {
                self.image = image;
            }
        }
        
        if (bPicNotReady && [url length] > 0) {
            m_filenameToSave = filename;
            [self startFetchingImage:url];
        }
        else {
            m_filenameToSave = nil;
        }
    }
    
    return self;
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
                
                /* save the image in app document folder */
                if (m_filenameToSave && [m_filenameToSave length] > 0) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString* path = [documentsDirectory stringByAppendingPathComponent:m_filenameToSave];
                    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
                    [data writeToFile:path atomically:YES];
                    m_filenameToSave = nil;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = image;
                });
            }
        }
    }];
}

@end
