//
//  WLRAppDelegate.m
//  WLRRoute
//
//  Created by Neo on 12/18/2016.
//  Copyright (c) 2016 Neo. All rights reserved.
//

#import "WLRAppDelegate.h"
#import <WLRRoute/WLRRoute.h>
#import "WLRSignHandler.h"
#import "WLRUserHandler.h"
#import "HBXCALLBACKHandler.h"
#import "WLRSignViewController.h"
@interface WLRAppDelegate()
@property(nonatomic,strong)HBXCALLBACKHandler * handler;
@end
@implementation WLRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.router = [[WLRRouter alloc]init];
    [self.router registerHandler:[[WLRSignHandler alloc]init] forRoute:@"/signin/:phone([0-9]+)"];
    [self.router registerHandler:[[WLRUserHandler alloc]init] forRoute:@"/user"];
//    [self.router registerBlock:^WLRRouteRequest *(WLRRouteRequest *request) {
//        return nil;
//    } forRoute:@"x-call-back/:action(.*)"];
    //实现x-call-back跳转协议
    //实例化x-call-back-handler处理关于"x-call-back"为host的请求
    HBXCALLBACKHandler * x_call_back_handler =[HBXCALLBACKHandler handlerWithRouter:self.router];
    //是否打开异常，debug状态下打开，方便调试，生产环境下关闭
    x_call_back_handler.enableException = YES;
    [x_call_back_handler loadLocalConfigWithPathName:@"config"];
    [x_call_back_handler setTrainsationBlock:^BOOL(UIViewController *targetViewController, UIViewController *sourceViewController, BOOL isModal, WLRRouteRequest *request) {
        if (isModal||![sourceViewController isKindOfClass:[UINavigationController class]]) {
            [sourceViewController presentViewController:targetViewController animated:YES completion:nil];
        }
        else if ([sourceViewController isKindOfClass:[UINavigationController class]]){
            UINavigationController * nav = (UINavigationController *)sourceViewController;
            [nav pushViewController:targetViewController animated:YES];
        }
        return YES;
    }];
    self.handler = x_call_back_handler;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
