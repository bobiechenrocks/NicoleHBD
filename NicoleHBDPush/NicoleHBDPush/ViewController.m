//
//  ViewController.m
//  NicoleHBDPush
//
//  Created by bobiechen on 6/28/15.
//  Copyright (c) 2015 bobiechen. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pushMessageInput;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupParse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupParse {
    // Enable storing and querying data from Local Datastore. Remove this line if you don't want to
    // use Local Datastore features or want to use cachePolicy.
    [Parse enableLocalDatastore];
    
    // ****************************************************************************
    // Uncomment this line if you want to enable Crash Reporting
    // [ParseCrashReporting enable];
    //
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:@"HEH8DGG9z2ZtnrCiku8cmCI5ZXDUfaHlMXzu1mNJ"
                  clientKey:@"OGjbbcPxgTptxgYDxnDSZOHy189SPk9VZAKMzikm"];

}

- (IBAction)sendPush:(id)sender {
    if ([self.pushMessageInput.text length] <= 0) {
        return;
    }
    
    NSString* quotedMessage = [NSString stringWithFormat:@"\"%@\"", self.pushMessageInput.text];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sending Message"
                                                    message:quotedMessage delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        // Send a notification to all devices subscribed to the "Giants" channel.
        PFPush *push = [[PFPush alloc] init];
        
        NSDictionary* data = @{@"alert": self.pushMessageInput.text,
                               @"badge": @"Increment",
                               @"sound": @"default"};
        [push setChannels:@[@"happybirthday", @"updates"]];
        [push setData:data];
        [push sendPushInBackground];
    }
}

@end
