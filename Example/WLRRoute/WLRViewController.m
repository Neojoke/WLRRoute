//
//  WLRViewController.m
//  WLRRoute
//
//  Created by Neo on 12/18/2016.
//  Copyright (c) 2016 Neo. All rights reserved.
//

#import "WLRViewController.h"
#import <WLRRoute/WLRRoute.h>
#import "WLRAppDelegate.h"
@interface WLRViewController ()
@property(nonatomic,weak)WLRRouter * router;
@end

@implementation WLRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.router = ((WLRAppDelegate *)[UIApplication sharedApplication].delegate).router;
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)userClick:(UIButton *)sender {
    [self.router handleURL:[NSURL URLWithString:@"WLRDemo://com.wlrroute.demo/user"] primitiveParameters:@{@"user":@"Neo~🙃🙃"} targetCallBack:^(NSError *error, id responseObject) {
        NSLog(@"UserCallBack");
    } withCompletionBlock:^(BOOL handled, NSError *error) {
        NSLog(@"UserHandleCompletion");
    }];
}
- (IBAction)SiginClick:(UIButton *)sender {
    [self.router handleURL:[NSURL URLWithString:@"WLRDemo://com.wlrroute.demo/signin/13812345432"] primitiveParameters:nil targetCallBack:^(NSError *error, id responseObject) {
        NSLog(@"SiginCallBack");
    } withCompletionBlock:^(BOOL handled, NSError *error) {
        NSLog(@"SiginHandleCompletion");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
