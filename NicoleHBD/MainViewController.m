//
//  MainViewController.m
//  NicoleHBD
//
//  Created by bobiechen on 6/24/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import "MainViewController.h"
#import "Utilities.h"
#import "BCWebImageView.h"
#import "BypassTouchImageView.h"
#import "PicsCollectionViewController.h"
#import "ZoomZoomPicView.h"
#import "Definitions.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScroll;
@property (weak, nonatomic) IBOutlet BypassTouchImageView *hollowCircleView;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;

@property (strong, nonatomic) ZoomZoomPicView* zoomInPicView;

@property (strong, nonatomic) NSDictionary* birthdayJson;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareMainView];
    [self prepareBirthdayJSON];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareMainView {
    [self.view setBackgroundColor:[Utilities colorWithHex:0xfacade]];
    [self.baseScroll setPagingEnabled:YES];
    [self.baseScroll setBounces:NO];
    [self.baseScroll setShowsHorizontalScrollIndicator:NO];
    [self.baseScroll setShowsVerticalScrollIndicator:NO];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnThumb:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.baseScroll addGestureRecognizer:singleTap];
    
    self.hollowCircleView.backgroundColor = [UIColor clearColor];
    self.hollowCircleView.image = [UIImage imageNamed:@"facade_circle.png"];
    self.hollowCircleView.bypassParent = self.baseScroll;
    
    CGFloat circle1size = 290.0f, circle2size = 275.0f;
    CGFloat circle1origin = (self.hollowCircleView.frame.size.width - circle1size)/2.0f;
    BypassTouchImageView* circle1 = [[BypassTouchImageView alloc] initWithFrame:CGRectMake(circle1origin, circle1origin, circle1size, circle1size)];
    [self.hollowCircleView addSubview:circle1];
    [circle1 setBackgroundColor:[UIColor clearColor]];
    [circle1.layer setCornerRadius:circle1size/2.0f];
    [circle1.layer setBorderColor:[UIColor whiteColor].CGColor];
    [circle1.layer setBorderWidth:5.0f];
    
    CGFloat circle2origin = (self.hollowCircleView.frame.size.width - circle2size)/2.0f;
    BypassTouchImageView* circle2 = [[BypassTouchImageView alloc] initWithFrame:CGRectMake(circle2origin, circle2origin, circle2size, circle2size)];
    [self.hollowCircleView addSubview:circle2];
    [circle2 setBackgroundColor:[UIColor clearColor]];
    [circle2.layer setCornerRadius:circle2size/2.0f];
    [circle2.layer setBorderColor:[UIColor whiteColor].CGColor];
    [circle2.layer setBorderWidth:7.0f];

}

- (void)prepareBirthdayJSON {
    self.loadingIndicator.hidden = NO;
    [self.loadingIndicator startAnimating];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:kBirthdayJsonUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0f];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{ self.loadingIndicator.hidden = YES; });
        BOOL bUseUserDefault = NO;
        
        if (connectionError) {
            /* fall back to cached json in NSUserDefault */
            bUseUserDefault = YES;
            NSLog(@"sendAsynchronousRequest error: %@", [connectionError localizedDescription]);
        }
        else {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            if (httpResponse.statusCode != 200) {
                bUseUserDefault = YES;
            }
            else {
                NSError* jsonError = nil;
                NSDictionary* birthdayJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
                [[NSUserDefaults standardUserDefaults] setObject:birthdayJson forKey:kBirthdayJsonKey];
                self.birthdayJson = birthdayJson;
            }
        }
        
        if (bUseUserDefault) {
            self.birthdayJson = [[NSUserDefaults standardUserDefaults] objectForKey:kBirthdayJsonKey];
            if (!self.birthdayJson) {
                NSLog(@"ohoh, even the user-default does not have the JSON :(");
            }
        }
        
        if (self.birthdayJson) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self prepareBirthdayPicScroll];
            });
        }
    }];
}

- (void)prepareBirthdayPicScroll {
    if (!self.birthdayJson) {
        return;
    }
    
    for (UIView* subview in self.baseScroll.subviews) {
        if ([subview isKindOfClass:[BCWebImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    if (self.birthdayJson[kBirthdayJsonKeyWishes]) {
        NSArray* wishes = self.birthdayJson[kBirthdayJsonKeyWishes];
        
        NSUInteger count = 0;
        for (NSDictionary* wish in wishes) {
            NSString* picName = wish[kBirthdayJsonKeyPic];
            NSString* picUrl = wish[kBirthdayJsonKeyPicUrl];
            if ([picName length] <= 0 && [picUrl length] <= 0) {
                continue;
            }
            
            CGFloat baseScrollSize = self.baseScroll.frame.size.width;
            BCWebImageView* picImageView = [[BCWebImageView alloc] initWithFrame:CGRectMake(count*baseScrollSize, 0.0f, baseScrollSize, baseScrollSize)
                                                                        filename:[NSString stringWithFormat:@"%@_thumb.jpg", picName]
                                                                             url:picUrl];
            [self.baseScroll addSubview:picImageView];
                        
            count++;
        }
        
        [self.baseScroll setContentSize:CGSizeMake(count*self.baseScroll.frame.size.width, self.baseScroll.frame.size.height)];
    }
}

- (void)handleTapOnThumb:(UIGestureRecognizer*)recognizer {
    [self zoomInButtonClicked:nil];
}

#pragma mark - UI actions
- (IBAction)galleryButtonClicked:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    PicsCollectionViewController* picsVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PicsCollectionViewController"];
    picsVC.picsAndWishes = self.birthdayJson[kBirthdayJsonKeyWishes];
    [self.navigationController pushViewController:picsVC animated:YES];
}

- (IBAction)zoomInButtonClicked:(id)sender {
    if (!self.zoomInPicView) {
        self.zoomInPicView = [[ZoomZoomPicView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    self.zoomInPicView.alpha = 0.0f;
    self.zoomInPicView.hidden = NO;
    [self.view addSubview:self.zoomInPicView];
    
    NSUInteger currentScrollIndex = (NSUInteger)((self.baseScroll.contentOffset.x + self.baseScroll.frame.size.width - 1.0f) / self.baseScroll.frame.size.width);
    if (currentScrollIndex < [self.birthdayJson[kBirthdayJsonKeyWishes] count]) {
        NSDictionary* wish = self.birthdayJson[kBirthdayJsonKeyWishes][currentScrollIndex];
        NSString* filename = [NSString stringWithFormat:@"%@_full.jpg", wish[kBirthdayJsonKeyPic]];
        NSString* url = wish[kBirthdayJsonKeyPicUrl];
        NSString* wishWords = wish[kBirthdayJsonKeyWords];
        [self.zoomInPicView preparePicView:filename url:url wishWords:wishWords];
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        self.zoomInPicView.alpha = 1.0f;
    }];
}

@end
