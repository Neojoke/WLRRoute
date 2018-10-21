//
//  HBConfigRoutingHandler.m
//  WLRRoute_Example
//
//  Created by Neo on 2018/10/21.
//  Copyright © 2018 Neo. All rights reserved.
//

#import "HBConfigRoutingHandler.h"
#import <WLRRoute/WLRRouteRequest.h>
#import <WLRRoute/NSError+WLRError.h>
#import <WLRRoute/WLRRouter.h>
#import <WLRRoute/UIViewController+WLRRoute.h>
#import <MJExtension/MJExtension.h>
#import <UIKit/UIKit.h>
#import "RuntimeInvoker.h"
@implementation HBSeletorArgType
@end
@interface HBConfigRoutingHandler()
@end
@implementation HBConfigRoutingHandler
-(NSMutableDictionary<NSString *,HBRoutingConfigInfo *> *)configInfoDict{
    if(!_configInfoDict){
        _configInfoDict = [[NSMutableDictionary alloc]init];
    }
    return _configInfoDict;
}
-(void)configRouterWith:(WLRRouter *)router configInfoDict:(NSDictionary<NSString *,HBRoutingConfigInfo *> *)configInfoDict{
    if (configInfoDict) {
        self.configInfoDict = [[NSMutableDictionary alloc]initWithDictionary:configInfoDict];
        for (NSString * routerExp in configInfoDict.allKeys) {
            [router registerHandler:self forRoute:routerExp];
        }
    }
}
+(HBConfigRoutingHandler *)handlerWithRouter:(WLRRouter *)router configInfoDict:(NSDictionary<NSString *,HBRoutingConfigInfo*>*)configInfoDict;{
    NSAssert(router, @"HBConfigRoutingHandler:router object is nil");
    HBConfigRoutingHandler * handler = [[HBConfigRoutingHandler alloc]init];
    handler.router = router;
    if (configInfoDict) {
        handler.configInfoDict = [[NSMutableDictionary alloc]initWithDictionary:configInfoDict];
    }
    [handler configRouterWith:router configInfoDict:configInfoDict];
    return handler;
}
-(BOOL)shouldHandleWithRequest:(WLRRouteRequest *)request{
    NSString * routerExpression = request.routeExpression;
    HBRoutingConfigInfo * info = [self.configInfoDict objectForKey:routerExpression];
    if (info) {
        return YES;
    }
    else{
        return NO;
    }
}
-(BOOL)handleRequest:(WLRRouteRequest *)request error:(NSError *__autoreleasing *)error{
    WLRRouteCompletionHandler originalCallBack = request.targetCallBack;
    NSString * routerExpression = request.routeExpression;
    HBRoutingConfigInfo * info = [self.configInfoDict objectForKey:routerExpression];
    BOOL returnValue = NO;
    UIViewController * controller = nil;
    NSDictionary * params = request.primitiveParams;
    Class vc_class = NSClassFromString(info.className);
    if (vc_class == nil) {
        NSError * runtime_error = [NSError errorWithDomain:@"HBConfigRoutingHandler" code:500 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"not found target vc_class with class string:%@",info.className]}];
        *error = runtime_error;
        return NO;
    }
    switch (info.initWay) {
        case HBRoutingConfigVCInitTypeDefault:{
            controller = [[vc_class alloc]init];
            if (!(controller&& [controller isKindOfClass:[UIViewController class]])) {
                NSError * runtime_error = [NSError errorWithDomain:@"HBConfigRoutingHandler" code:500 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"not found target vc_class with class string:%@",info.className]}];
                *error = runtime_error;
                return NO;
            }
            if (params.allKeys.count>0) {
                [controller mj_setKeyValues:params];
            }
            returnValue = YES;
            break;
        }
        case HBRoutingConfigVCInitTypeStoryBoard:{
            UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:info.storyBoardName bundle:nil];
            if (!storyBoard) {
                NSError * runtime_error = [NSError errorWithDomain:@"HBConfigRoutingHandler" code:500 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"storyBoardName(%@) is not right!",info.storyBoardName]}];
                *error = runtime_error;
                return NO;
            }
            controller = [storyBoard instantiateViewControllerWithIdentifier:info.storyBoardId];
            if (!controller) {
                NSError * runtime_error = [NSError errorWithDomain:@"HBConfigRoutingHandler" code:500 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"storyBoardId(%@) is not right!With storyBoard name:%@",info.storyBoardId,info.storyBoardName]}];
                *error = runtime_error;
                return NO;
                
            }
            if (params.allKeys.count>0) {
                [controller mj_setKeyValues:params];
            }
            returnValue = YES;
            break;
        }
        case HBRoutingConfigVCInitTypeStaticMethod:{
            Class target_class = NSClassFromString(info.targetClassName);
            SEL targetSelector = NSSelectorFromString(info.selectorString);
            NSArray<HBSeletorArgType *> * argInfos = info.selectorArginfos;
            if (target_class && targetSelector && argInfos && [argInfos isKindOfClass: [NSArray class]] && argInfos.count>0) {
                
            }
            else{
                NSError * runtime_error = [NSError errorWithDomain:@"HBConfigRoutingHandler" code:500 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"staticMethod is not right,with targetClassName(%@),selectorString(%@),arginfos(%@)",info.targetClassName,info.selectorString,info.selectorArginfos]}];
                *error = runtime_error;
                return NO;
            }
            NSMutableArray *  arguments = [NSMutableArray array];
            for (NSUInteger i = 0; i<argInfos.count; i++) {
                HBSeletorArgType * infoType = [argInfos objectAtIndex:i];
                NSString * argName = infoType.argName;
                NSString * argClassName = infoType.argClassName;
                id arg_obj = [params objectForKey:argName];
                if (arg_obj) {
                    if ([arg_obj isKindOfClass:[NSDictionary class]]) {
                        arg_obj = [NSClassFromString(argClassName) mj_objectWithKeyValues:arg_obj];
                    }
                    [arguments addObject:arg_obj];
                }
                else{
                    NSError * runtime_error = [NSError errorWithDomain:@"HBConfigRoutingHandler" code:500 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"staticMethod init error,with targetClassName(%@),selectorString(%@),arginfos(%@),param(%@)",info.targetClassName,info.selectorString,info.selectorArginfos,params]}];
                    *error = runtime_error;
                    return NO;
                }
            }
           controller = [target_class invoke:info.selectorString arguments:arguments];
            returnValue = YES;
            }
            break;
                              
        default:
            returnValue = NO;
            break;
    }
    if ([controller isKindOfClass:[UIViewController class]]) {
        
    }
    else{
        NSError * runtime_error = [NSError errorWithDomain:@"HBConfigRoutingHandler" code:500 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"handleRequest error,vc object is nil"]}];
        *error = runtime_error;
        return NO;
    }
    controller.wlr_request = request;
    UIViewController * source_vc = [self sourceViewControllerForTransitionWithRequest:request];
    [self transitionWithWithRequest:request sourceViewController:source_vc targetViewController:controller isPreferModal:info.isModal error:error];
    return returnValue;
}
-(UIViewController *)sourceViewControllerForTransitionWithRequest:(WLRRouteRequest *)request{
    return [UIApplication sharedApplication].windows[0].rootViewController;
}
-(BOOL)transitionWithWithRequest:(WLRRouteRequest *)request sourceViewController:(UIViewController *)sourceViewController targetViewController:(UIViewController *)targetViewController isPreferModal:(BOOL)isPreferModal error:(NSError *__autoreleasing *)error{
    if (isPreferModal||![sourceViewController isKindOfClass:[UINavigationController class]]) {
        [sourceViewController presentViewController:targetViewController animated:YES completion:nil];
    }
    else if ([sourceViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController * nav = (UINavigationController *)sourceViewController;
        [nav pushViewController:targetViewController animated:YES];
    }
    return YES;
}
@end
@implementation HBRoutingConfigInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"selectorArginfos":@"HBSeletorArgType"};
}
@end
