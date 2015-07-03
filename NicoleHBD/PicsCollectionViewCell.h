//
//  PicsCollectionViewCell.h
//  NicoleHBD
//
//  Created by bobiechen on 7/2/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicsCollectionViewCell : UICollectionViewCell

@property (copy, nonatomic) NSString* picName;
@property (copy, nonatomic) NSString* picThumbUrl;

- (void)preparePicImage;

@end
