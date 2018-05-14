//
//  UserModule.m
//  WLRRoute_Example
//
//  Created by Neo on 2018/5/14.
//  Copyright © 2018年 Neo. All rights reserved.
//

#import "UserModule.h"
#import <WLRRoute/WLRRoute.h>

@implementation UserModule
+(BOOL)handleRequest:(WLRRouteRequest *)request actionName:(NSString *)actionName completionHandler:(WLRRouteCompletionHandler)completionHandler
{
    NSString * phone =request[@"phone"];
    NSString * subPath =  request[@"subPath"];
    NSSelectorFromString(subPath);
    UIViewController * vc = [self LoginViewController:phone];
    vc.wlr_request = request;
    /*
     转场
     */
    return YES;
}
+(UIViewController *)UserInfoViewController:(NSString *)userId{
    
    return nil;
}
+(UIViewController *)LoginViewController:(NSString *)Phone{
    NSData * config_data = [[NSData alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"config" ofType:@"json"]];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:config_data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary * vc_infos = [dict objectForKey:@"vc_infos"];
    NSDictionary * login_vc_info = [vc_infos objectForKey:@"HBLoginViewController"];
    NSString * storyBoardName = [login_vc_info objectForKey:@"StoryBoardName"];
    NSString * storyBoardId = [login_vc_info objectForKey:@"StoryBoardId"];
    UIStoryboard * board = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    UIViewController * vc = [board instantiateViewControllerWithIdentifier:storyBoardId];
    return vc;
}
@end
