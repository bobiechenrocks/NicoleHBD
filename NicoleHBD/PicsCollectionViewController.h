//
//  PicsCollectionViewController.h
//  NicoleHBD
//
//  Created by bobiechen on 7/1/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PicsCollectionDelegate <NSObject>

- (NSArray*)providePicsAndWishes;

@end

@interface PicsCollectionViewController : UICollectionViewController

@property (weak, nonatomic) NSArray* picsAndWishes;

@end
