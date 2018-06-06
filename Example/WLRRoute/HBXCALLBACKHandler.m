//
//  HBXCALLBACKHandler.m
//  WLRRoute_Example
//
//  Created by Neo on 2018/4/11.
//  Copyright © 2018年 Neo. All rights reserved.
//

#import "HBXCALLBACKHandler.h"
#import <WLRRoute/WLRRouteRequest.h>
#import <WLRRoute/NSError+WLRError.h>
#import <WLRRoute/WLRRouter.h>
#import <WLRRoute/UIViewController+WLRRoute.h>
@interface HBXCALLBACKVCInfo:NSObject
@property(nonatomic,copy)NSString * vcName;
@property(nonatomic,copy)NSString * storyBoardName;
@property(nonatomic,copy)NSString * storyBoardId;
@end
@implementation HBXCALLBACKVCInfo

@end
@interface HBXCALLBACKRouteExpressionInfo:NSObject
@property(nonatomic,copy)NSString * routeExpression;
@property(nonatomic,copy)NSString * className;
@property(nonatomic,strong)NSDictionary * kvcMapInfo;
@property(nonatomic,strong)NSNumber * isModal;
@end
@implementation HBXCALLBACKRouteExpressionInfo
@end
@interface HBXCALLBACKHandler()
@property(nonatomic,strong)NSMutableDictionary * actionsMap;
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic,strong) NSMutableDictionary * vc_config_info;
@property (nonatomic,strong)NSMutableDictionary * route_expression_info;
@end
@implementation HBXCALLBACKHandler
-(NSMutableDictionary *)vc_config_info{
    if (!_vc_config_info) {
        _vc_config_info = [[NSMutableDictionary alloc]init];
    }
    return _vc_config_info;
}
-(NSMutableDictionary *)route_expression_info{
    if (!_route_expression_info) {
        _route_expression_info = [[NSMutableDictionary alloc]init];
    }
    return _route_expression_info;
}
+(HBXCALLBACKHandler *)handlerWithRouter:(WLRRouter *)router{
    NSParameterAssert(router != nil);
    HBXCALLBACKHandler * handler = [[HBXCALLBACKHandler alloc]init];
    handler.router = router;
    return handler;
}
-(NSMutableDictionary *)actionsMap{
    if (!_actionsMap) {
        _actionsMap = [NSMutableDictionary dictionary];
    }
    return _actionsMap;
}

- (NSRecursiveLock *)lock
{
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}
-(BOOL)shouldHandleWithRequest:(WLRRouteRequest *)request{
    return YES;
}
-(UIViewController *)targetViewControllerWithVCInfo:(HBXCALLBACKVCInfo *)vcInfo routeExpressionInfo:(HBXCALLBACKRouteExpressionInfo *)routeExpressionInfo request:(WLRRouteRequest *)request{
    if (vcInfo != nil && routeExpressionInfo !=nil && request != nil) {
        UIViewController * controller = nil;
        if (vcInfo.storyBoardName != nil && vcInfo.storyBoardId != nil) {
            UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:vcInfo.storyBoardName bundle:nil];
            controller = [storyBoard instantiateViewControllerWithIdentifier:vcInfo.storyBoardId];
        }
        else{
            controller = [[NSClassFromString(vcInfo.vcName) alloc]init];
        }
        if (routeExpressionInfo.kvcMapInfo) {
            NSMutableDictionary * target_kvc_dict = [[NSMutableDictionary alloc]init];
            for (NSString * key in routeExpressionInfo.kvcMapInfo.allKeys) {
                NSString * property_key = [routeExpressionInfo.kvcMapInfo objectForKey:key];
                id value = [request objectForKeyedSubscript:key];
                if (property_key && value) {
                    [target_kvc_dict setObject:value forKey:property_key];
                }
            }
            if (target_kvc_dict.allKeys.count>0 && controller != nil) {
                [controller setValuesForKeysWithDictionary:target_kvc_dict];
            }
        }
        return controller;
    }
    else{
        return nil;
    }
}
- (BOOL)preferModalPresentationWithVCInfo:(HBXCALLBACKVCInfo *)vcInfo routeExpressionInfo:(HBXCALLBACKRouteExpressionInfo *)routeExpressionInfo request:(WLRRouteRequest *)request;{
    return routeExpressionInfo.isModal.boolValue;
}
-(UIViewController *)targetViewControllerWithRequest:(WLRRouteRequest *)request{
    NSString * router_expression = request.routeExpression;
    if (router_expression != nil) {
        return nil;
    }
    HBXCALLBACKRouteExpressionInfo * router_expression_info = [self.route_expression_info objectForKey:router_expression];
    if (router_expression_info == nil) {
        return nil;
    }
    Class impl = [self implClassWithActionName:router_expression];
    if (impl==nil) {
        return nil;
    }
    HBXCALLBACKVCInfo * vc_info = [self.vc_config_info objectForKey:router_expression_info.className];
    if (vc_info == nil) {
        return nil;
    }
    UIViewController * controller = nil;
    if (vc_info.storyBoardName != nil && vc_info.storyBoardId != nil) {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:vc_info.storyBoardName bundle:nil];
        controller = [storyBoard instantiateViewControllerWithIdentifier:vc_info.storyBoardId];
        
    }
    else{
        controller = [[NSClassFromString(vc_info.vcName) alloc]init];
    }
    if (router_expression_info.kvcMapInfo) {
        NSMutableDictionary * target_kvc_dict = [[NSMutableDictionary alloc]init];
        for (NSString * key in router_expression_info.kvcMapInfo.allKeys) {
            NSString * property_key = [router_expression_info.kvcMapInfo objectForKey:key];
            id value = [request objectForKeyedSubscript:key];
            if (property_key && value) {
                [target_kvc_dict setObject:value forKey:property_key];
            }
        }
        if (target_kvc_dict.allKeys.count>0 && controller != nil) {
            [controller setValuesForKeysWithDictionary:target_kvc_dict];
        }
    }
    return controller;
}
-(UIViewController *)sourceViewControllerForTransitionWithRequest:(WLRRouteRequest *)request{
    return [UIApplication sharedApplication].windows[0].rootViewController;
}

-(BOOL)transitionWithWithRequest:(WLRRouteRequest *)request sourceViewController:(UIViewController *)sourceViewController targetViewController:(UIViewController *)targetViewController isPreferModal:(BOOL)isPreferModal error:(NSError *__autoreleasing *)error{
    if (self.trainsationBlock) {
        return self.trainsationBlock(targetViewController,sourceViewController,isPreferModal,request);
    }
    else{
        //默认实现
        return YES;
    }
    return YES;
}

- (BOOL)preferModalPresentationWithRequest:(WLRRouteRequest *)request;{
    return NO;
}

-(void)registeModuleClass:(Class)implClass forActionName:(NSString *)actionName;{
    NSParameterAssert(implClass != nil);
    NSParameterAssert(actionName != nil);
//    if (![implClass conformsToProtocol:moduleProtocol]) {
//        if (self.enableException) {
//            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ module does not comply with %@ protocol", NSStringFromClass(implClass), NSStringFromProtocol(moduleProtocol)] userInfo:nil];
//        }
//        return;
//    }
    
//    if ([self checkValidModuleProtocol:moduleProtocol actionName:actionName]) {
//        if (self.enableException) {
//            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ protocol has been registed", NSStringFromProtocol(moduleProtocol)] userInfo:nil];
//        }
//        return;
//    }
    NSString *key = [NSString stringWithFormat:@"%@",actionName];
    NSString *value = NSStringFromClass(implClass);
    if (key.length > 0 && value.length > 0 && [actionName isKindOfClass:[NSString class]] && actionName.length>0) {
        [self.lock lock];
        [self.actionsMap addEntriesFromDictionary:@{key:value}];
        [self.lock unlock];
    }
    [self.router registerHandler:self forRoute:[NSString stringWithFormat:@"x-call-back/%@",actionName]];
}
//- (BOOL)checkValidModuleProtocol:(Protocol *)moduleProtocol actionName:(NSString *)actionName
//{
//    NSString * action_protocol = [NSString stringWithFormat:@"%@_%@",actionName,NSStringFromProtocol(moduleProtocol)];
//    NSString *moduleImpl = [[self moduleDict] objectForKey:action_protocol];
//    if (moduleImpl.length > 0) {
//        return YES;
//    }
//    return NO;
//}
-(BOOL)handleRequest:(WLRRouteRequest *)request error:(NSError *__autoreleasing *)error{
    NSLog(@"%@",request.queryParameters);
    NSString * x_success =request.queryParameters[@"x-success"];
    NSString * x_error = request.queryParameters[@"x-error"];
    NSURL * x_error_url = [NSURL URLWithString:x_error];
    NSURL * x_success_url = [NSURL URLWithString:x_success];
    NSString * routeExpression = [request.routeExpression stringByReplacingOccurrencesOfString:@"x-call-back/" withString:@""];
    WLRRouteCompletionHandler originalCallBack = request.targetCallBack;
    __weak typeof(self) weakSelf = self;
    WLRRouteCompletionHandler callBack = ^(NSError *callback_error,NSDictionary * responseObject){
        if (originalCallBack) {
            originalCallBack(callback_error,responseObject);
        }
        if (callback_error && x_error_url) {
            if (weakSelf.router) {
                [weakSelf.router handleURL:x_error_url primitiveParameters:responseObject targetCallBack:nil withCompletionBlock:nil];
            }
        }
        else if(x_success_url){
            if (weakSelf.router) {
                [weakSelf.router handleURL:x_success_url primitiveParameters:responseObject targetCallBack:nil withCompletionBlock:nil];
            }
        }

    };
    request.targetCallBack = callBack;
    Class impl = [self implClassWithActionName:routeExpression];
    if ([impl isSubclassOfClass:[UIViewController class]]) {
        if (routeExpression == nil) {
            return NO;
        }
        HBXCALLBACKRouteExpressionInfo * router_expression_info = [self.route_expression_info objectForKey:routeExpression];
        if (router_expression_info == nil) {
            return NO;
        }
        Class impl = [self implClassWithActionName:routeExpression];
        if (impl==nil) {
            return NO;
        }
        HBXCALLBACKVCInfo * vc_info = [self.vc_config_info objectForKey:router_expression_info.className];
        if (vc_info == nil) {
            return NO;
        }
        UIViewController * targetViewController = [self targetViewControllerWithVCInfo:vc_info routeExpressionInfo:router_expression_info request:request];
        targetViewController.wlr_request = request;
        UIViewController * sourceViewController = [self sourceViewControllerForTransitionWithRequest:request];
        BOOL isModal = [self preferModalPresentationWithVCInfo:vc_info routeExpressionInfo:router_expression_info request:request];
        return [self transitionWithWithRequest:request sourceViewController:sourceViewController targetViewController:targetViewController isPreferModal:isModal error:error];
    }
    else{
            if (impl == nil) {
                *error = [NSError WLRHandleRequestErrorWithMessage:[NSString stringWithFormat:@"not found module with actionName:%@",routeExpression]];
                return NO;
            }
    }
//    if (impl == nil) {
//        *error = [NSError WLRHandleRequestErrorWithMessage:[NSString stringWithFormat:@"not found module with actionName:%@",actionName]];
//        return NO;
//    }
//    BOOL isHandle = [impl handleRequest:request actionName:actionName completionHandler:callBack];
    return YES;
}
-(Class)implClassWithActionName:(NSString *)actionName{
    NSString * value = [self.actionsMap objectForKey:actionName];
    if (!value) {
        return nil;
    }
    if (value.length>0) {
        return NSClassFromString(value);
    }
    else{
        return nil;
    }
}
-(void)loadLocalConfigWithPathName:(NSString *)pathName{
    NSString * path = [[NSBundle mainBundle]pathForResource:pathName ofType:@"json"];
    NSData * data = [[NSData alloc]initWithContentsOfFile:path];
    if (data) {
        NSError * error = nil;
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            NSLog(@"HBXCallBack %@ config file prase error :%@!",pathName,error);
        }
        else{
            NSDictionary * route_expression_infos_dict = [dict objectForKey:@"route_expression_infos"];
            NSDictionary * vc_config_infos = [dict objectForKey:@"vc_config_infos"];
            for (NSString * route_expression_key in route_expression_infos_dict.allKeys) {
                NSDictionary * route_expression_info = [route_expression_infos_dict objectForKey:route_expression_key];
                NSString * routeExpression = [route_expression_info objectForKey:@"routeExpression"];
                NSString * className = [route_expression_info objectForKey:@"className"];
                NSNumber * isModal = [route_expression_info objectForKey:@"isModal"];
                NSDictionary * kvcMapInfo = [route_expression_info objectForKey:@"kvcMapInfo"];
                HBXCALLBACKRouteExpressionInfo * expressionInfo = [[HBXCALLBACKRouteExpressionInfo alloc]init];
                expressionInfo.routeExpression = routeExpression;
                expressionInfo.className = className;
                expressionInfo.isModal = isModal;
                expressionInfo.kvcMapInfo = kvcMapInfo;
                NSDictionary * vc_config_info_dict = [vc_config_infos objectForKey:expressionInfo.className];
                if (vc_config_info_dict == nil) {
                    continue;
                }
                HBXCALLBACKVCInfo * vc_config_info = [[HBXCALLBACKVCInfo alloc]init];
                vc_config_info.vcName = expressionInfo.className;
                vc_config_info.storyBoardId = [vc_config_info_dict objectForKey:@"StoryBoardId"];
                vc_config_info.storyBoardName = [vc_config_info_dict objectForKey:@"StoryBoardName"];
                [self.vc_config_info setObject:vc_config_info forKey:expressionInfo.className];
                [self.route_expression_info setObject:expressionInfo forKey:route_expression_key];
                [self registeModuleClass:NSClassFromString(vc_config_info.vcName) forActionName:expressionInfo.routeExpression];
            }
        }
    }
    else{
        NSLog(@"HBXCallBack not fount %@ config file!",pathName);
    }
}
@end
