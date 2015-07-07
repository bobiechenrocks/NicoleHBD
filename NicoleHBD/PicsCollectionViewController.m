//
//  PicsCollectionViewController.m
//  NicoleHBD
//
//  Created by bobiechen on 7/1/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import "PicsCollectionViewController.h"
#import "Utilities.h"
#import "PicsCollectionViewCell.h"
#import "ZoomZoomPicView.h"
#import "Definitions.h"

@interface PicsCollectionViewController ()

@property (strong, nonatomic) ZoomZoomPicView* zoomInPicView;

@end

@implementation PicsCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[PicsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.title = @"Happy Birthday!!";
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.picsAndWishes count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PicsCollectionViewCell *cell = (PicsCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    // Configure the cell
    if (indexPath.row < [self.picsAndWishes count]) {
        cell.picName = (self.picsAndWishes[indexPath.row])[kBirthdayJsonKeyPic];
        cell.picThumbUrl = (self.picsAndWishes[indexPath.row])[kBirthdayJsonKeyPicThumbUrl];
        [cell preparePicImage];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    CGFloat size = 72.0f;
    return CGSizeMake(size, size);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.zoomInPicView) {
        self.zoomInPicView = [[ZoomZoomPicView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    self.zoomInPicView.alpha = 0.0f;
    self.zoomInPicView.hidden = NO;
    [self.view addSubview:self.zoomInPicView];
    
    if (indexPath.row < [self.picsAndWishes count]) {
        NSDictionary* wish = self.picsAndWishes[indexPath.row];
        NSString* filename = [NSString stringWithFormat:@"%@_full.jpg", wish[kBirthdayJsonKeyPic]];
        NSString* url = wish[kBirthdayJsonKeyPicUrl];
        NSString* wishWords = wish[kBirthdayJsonKeyWords];
        [self.zoomInPicView preparePicView:filename url:url wishWords:wishWords];
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        self.zoomInPicView.alpha = 1.0f;
    }];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}
 
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSLog(@"%@ selected", indexPath.row);
}
*/

@end
