//
//  HBOldRoute.m
//  WLRRoute_Example
//
//  Created by Neo on 2018/5/14.
//  Copyright © 2018年 Neo. All rights reserved.
//

#import "HBOldRoute.h"
#import <WLRRoute/WLRRoute.h>
@implementation HBOldRoute
+(BOOL)handleRequest:(WLRRouteRequest *)request actionName:(NSString *)actionName completionHandler:(WLRRouteCompletionHandler)completionHandler
{
    UIViewController * vc =[self ViewControllerWithRequest:request actionName:actionName];
    vc.wlr_request = request;
    /*
     转场
     */
    return YES;
}
+(UIViewController *)ViewControllerWithRequest:(WLRRouteRequest *)request actionName:(NSString *)action{
    return nil;
}

@end
