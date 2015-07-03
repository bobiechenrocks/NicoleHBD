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
    CGFloat size = self.frame.size.width;
    self.picImageFromUrl = [[BCWebImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size, size)
                                                        filename:[NSString stringWithFormat:@"%@_thumb.jpg", self.picName]
                                                             url:self.picThumbUrl];
    [self addSubview:self.picImageFromUrl];
}

@end
