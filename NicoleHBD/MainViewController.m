//
//  MainViewController.m
//  NicoleHBD
//
//  Created by bobiechen on 6/24/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import "MainViewController.h"
#import "Utilities.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *baseScroll;
@property (weak, nonatomic) IBOutlet UIView *hollowCircleView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareMainView {
    [self.view setBackgroundColor:[Utilities colorWithHex:0xfacade]];
    [self.hollowCircleView setBackgroundColor:[Utilities colorWithHex:0xfacade]];
}

@end
