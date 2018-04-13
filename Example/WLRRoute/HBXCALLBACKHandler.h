//
//  HBXCALLBACKHandler.h
//  WLRRoute_Example
//
//  Created by Neo on 2018/4/11.
//  Copyright © 2018年 Neo. All rights reserved.
//

#import "WLRRouteHandler.h"
#import <WLRRoute/WLRRouteRequest.h>
@protocol  HBModuleProtocol<NSObject>
+(BOOL)handleRequest:(WLRRouteRequest *)request actionName:(NSString *)actionName completionHandler:(WLRRouteCompletionHandler)completionHandler;
@optional
+(UIViewController *)targetViewControllerWithRequest:(WLRRouteRequest *)request actionName:(NSString *)actionName completionHandler:(WLRRouteCompletionHandler)completionHandler;
+(void)transitionWithTargetViewController:(UIViewController *)ViewController request:(WLRRouteRequest *)request actionName:(NSString *)actionName;
@end
@class WLRRouter;
@interface HBXCALLBACKHandler : WLRRouteHandler
@property(nonatomic,weak)WLRRouter * router;
@property(nonatomic)BOOL enableException;
-(void)registeModuleProtocol:(Protocol *)moduleProtocol implClass:(Class)implClass forActionName:(NSString *)actionName;
@end
