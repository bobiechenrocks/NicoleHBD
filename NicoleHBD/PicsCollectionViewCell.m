//
//  PicsCollectionViewCell.m
//  NicoleHBD
//
//  Created by bobiechen on 7/2/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import "PicsCollectionViewCell.h"
#import "BCWebImageView.h"

@interface PicsCollectionViewCell ()

@property (strong, nonatomic) UIImageView* picImage;
@property (strong, nonatomic) BCWebImageView* picImageFromUrl;

@end

@implementation PicsCollectionViewCell

- (void)preparePicImage {
    BOOL bPicNotReady = NO;
    if ([self.picName length] > 0) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_thumb.jpg", self.picName]];
        if (!image) {
            bPicNotReady = YES;
        }
        else {
            CGFloat size = self.frame.size.width;
            self.picImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size, size)];
            self.picImage.image = image;
            [self addSubview:self.picImage];
            return;
        }
    }
    
    if (bPicNotReady && [self.picThumbUrl length] > 0) {
        CGFloat size = self.frame.size.width;
        self.picImageFromUrl = [[BCWebImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size, size) andUrl:self.picThumbUrl];
        [self addSubview:self.picImageFromUrl];
    }
}

@end
