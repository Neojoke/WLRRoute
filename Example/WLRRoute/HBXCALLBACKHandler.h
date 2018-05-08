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
/*
 return YES为可以进行跳转，return NO则表示不可跳转
 */
+(BOOL)handleRequest:(WLRRouteRequest *)request actionName:(NSString *)actionName completionHandler:(WLRRouteCompletionHandler)completionHandler;
@optional
/*
 如何获取控制器的便利方法
 */
+(UIViewController *)targetViewControllerWithRequest:(WLRRouteRequest *)request actionName:(NSString *)actionName completionHandler:(WLRRouteCompletionHandler)completionHandler;
/*
 进行转场的便利方法
 */
+(void)transitionWithTargetViewController:(UIViewController *)ViewController request:(WLRRouteRequest *)request actionName:(NSString *)actionName;
@end
@class WLRRouter;
@interface HBXCALLBACKHandler : WLRRouteHandler
@property(nonatomic,weak)WLRRouter * router;
@property(nonatomic)BOOL enableException;
-(void)registeModuleProtocol:(Protocol *)moduleProtocol implClass:(Class)implClass forActionName:(NSString *)actionName;
@end
