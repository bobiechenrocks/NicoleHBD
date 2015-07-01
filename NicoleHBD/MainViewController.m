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

NSString* const kBirthdayJsonUrl = @"http://bobiechenrocks.appspot.com/nicoleBirthdayJSON";
NSString* const kBirthdayJsonKey = @"birthdayJson";
NSString* const kBirthdayJsonKeyWishes = @"wishes";
NSString* const kBirthdayJsonKeyPic = @"pic";
NSString* const kBirthdayJsonKeyPicUrl = @"pic_url";
NSString* const kBirthdayJsonKeyWords = @"words";

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScroll;
@property (weak, nonatomic) IBOutlet BypassTouchImageView *hollowCircleView;

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
    
    self.hollowCircleView.backgroundColor = [UIColor clearColor];
    self.hollowCircleView.image = [UIImage imageNamed:@"facade_circle.png"];
    self.hollowCircleView.bypassParent = self.baseScroll;
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
    
    if (self.birthdayJson[kBirthdayJsonKeyWishes]) {
        NSArray* wishes = self.birthdayJson[kBirthdayJsonKeyWishes];
        
        NSUInteger count = 0;
        for (NSDictionary* wish in wishes) {
            NSString* picName = wish[kBirthdayJsonKeyPic];
            NSString* picUrl = wish[kBirthdayJsonKeyPicUrl];
            if ([picName length] <= 0 && [picUrl length] <= 0) {
                continue;
            }
            
            BOOL bInvalidPicName = NO;
            if ([picName length] > 0) {
                CGFloat baseScrollSize = self.baseScroll.frame.size.width;
                UIImage* pic = [UIImage imageNamed:[NSString stringWithFormat:@"%@_thumb.jpg", picName]];
                if (pic) {
                    UIImageView* picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(count*baseScrollSize, 0.0f, baseScrollSize, baseScrollSize)];
                    picImageView.image = pic;
                    [self.baseScroll addSubview:picImageView];
                }
                else {
                    bInvalidPicName = YES;
                }
            }
            else {
                bInvalidPicName = YES;
            }
            
            if (bInvalidPicName && [picUrl length] > 0) {
                CGFloat baseScrollSize = self.baseScroll.frame.size.width;
                BCWebImageView* picImageview = [[BCWebImageView alloc] initWithFrame:CGRectMake(count*baseScrollSize, 0.0f, baseScrollSize, baseScrollSize) andUrl:picUrl];
                [self.baseScroll addSubview:picImageview];
            }
            
            count++;
        }
        
        [self.baseScroll setContentSize:CGSizeMake(count*self.baseScroll.frame.size.width, self.baseScroll.frame.size.height)];
    }
}

@end
