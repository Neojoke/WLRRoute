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
@interface WLRViewController ()<WLRRouteMiddleware>
@property(nonatomic,weak)WLRRouter * router;
@end

@implementation WLRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.router = ((WLRAppDelegate *)[UIApplication sharedApplication].delegate).router;
    [self.router addMiddleware:self];
	// Do any additional setup after loading the view, typically from a nib.
}
-(NSDictionary *)middlewareHandleRequestWith:(WLRRouteRequest *)primitiveRequest error:(NSError *__autoreleasing *)error{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.router removeMiddleware:self];
//    });)
    return nil;
    //test:
//    *error = [NSError WLRMiddlewareRaiseErrorWithMsg:[NSString stringWithFormat:@"%@ raise error",NSStringFromClass([self class])]];
//    return @{@"result":@"yes"};
}
- (IBAction)userClick:(UIButton *)sender {
    [self.router handleURL:[NSURL URLWithString:@"WLRDemo://com.wlrroute.demo/user"] primitiveParameters:@{@"user":@"Neo~🙃🙃"} targetCallBack:^(NSError *error, id responseObject) {
        NSLog(@"UserCallBack");
    } withCompletionBlock:^(BOOL handled, NSError *error) {
        NSLog(@"UserHandleCompletion");
    }];
}
- (IBAction)SiginClick:(UIButton *)sender {
    [self.router handleURL:[NSURL URLWithString:@"WLRDemo://x-call-back/signin?x-success=WLRDemo%3A%2F%2Fx-call-back%2Fuser&phone=17621425586"] primitiveParameters:nil targetCallBack:^(NSError *error, id responseObject) {
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
