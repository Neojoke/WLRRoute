///
//  HBXCallBackHander.m
//  HBStockWarning
//
//  Created by Neo on 2018/6/7.
//  Copyright © 2018年 Touker. All rights reserved.
//

#import "HBXCallBackHander.h"
#import <WLRRoute/WLRRouteRequest.h>
#import <WLRRoute/NSError+WLRError.h>
#import <WLRRoute/WLRRouter.h>
#import <WLRRoute/UIViewController+WLRRoute.h>
#import <MJExtension/MJExtension.h>
typedef NS_ENUM(NSUInteger, HBInitialWay) {
    HBInitialWayDefault=0,
    HBInitialWayStoryBoard=1,
    HBInitialWayStaticMethod=2
};
@protocol HBClassInfoModelFactoryInitialInfoProtocol <NSObject>
@property(nonatomic,copy)NSString * targetClassName;
@property(nonatomic,copy)NSString * selectorString;
/*
 "[a#s,b#uint,c]"
 */
@property(nonatomic,strong)NSArray * paramsInfoString;
@end
@interface HBXCFactoryInfoModel:NSObject<HBClassInfoModelFactoryInitialInfoProtocol>

@end
@implementation HBXCFactoryInfoModel
@synthesize targetClassName;
@synthesize selectorString;
@synthesize paramsInfoString;
@end
@protocol HBClassInfoModelProtocol <NSObject>
@property(nonatomic)HBInitialWay initWay;
@property(nonatomic,copy)NSString * className;
@property(nonatomic,copy)NSString * storyBoardName;
@property(nonatomic,copy)NSString * storyBoardId;
@property(nonatomic)HBXCFactoryInfoModel * factoryInitialInfo;
@end

@interface HBXCallBackVCInfo:NSObject<HBClassInfoModelProtocol>
@end
@implementation HBXCallBackVCInfo
@synthesize initWay;
@synthesize className;
@synthesize storyBoardId;
@synthesize storyBoardName;
@synthesize factoryInitialInfo;
+(NSDictionary *)mj_objectClassInArray{
    return @{@"factoryInitialInfo":@"HBXCFactoryInfoModel"};
}
@end
@interface HBXCallBackRouteExpressionInfo:NSObject
@property(nonatomic,copy)NSString * routeExpression;
@property(nonatomic,copy)NSString * className;
@property(nonatomic,strong)NSDictionary * kvcMapInfo;
@property(nonatomic,strong)NSNumber * isModal;
@end
@implementation HBXCallBackRouteExpressionInfo
@end
@interface HBXCallBackHander()
@property(nonatomic,strong)NSMutableDictionary * actionsMap;
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic,strong) NSMutableDictionary * vc_config_info;
@property (nonatomic,strong)NSMutableDictionary * route_expression_info;
@end
@implementation HBXCallBackHander
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
+(HBXCallBackHander *)handlerWithRouter:(WLRRouter *)router{
    NSParameterAssert(router != nil);
    HBXCallBackHander * handler = [[HBXCallBackHander alloc]init];
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
#pragma mark -handler protocol
-(BOOL)shouldHandleWithRequest:(WLRRouteRequest *)request{
    return YES;
}
-(UIViewController *)targetViewControllerWithVCInfo:(HBXCallBackVCInfo *)vcInfo routeExpressionInfo:(HBXCallBackRouteExpressionInfo *)routeExpressionInfo request:(WLRRouteRequest *)request{
    if (vcInfo != nil && routeExpressionInfo !=nil && request != nil) {
        UIViewController * controller = nil;
        NSMutableDictionary * target_kvc_dict = [[NSMutableDictionary alloc]init];
        if (routeExpressionInfo.kvcMapInfo) {
            for (NSString * property_key in routeExpressionInfo.kvcMapInfo.allKeys) {
                NSString * params_key = [routeExpressionInfo.kvcMapInfo objectForKey:property_key];
                NSArray * propertyInfoArray = [property_key componentsSeparatedByString:@"#"];
                NSString *propertyName = propertyInfoArray.firstObject;
                NSString *propertyType;
                if (propertyInfoArray.count>1) {
                    propertyType=[propertyInfoArray objectAtIndex:1];
                }
                id value = [request objectForKeyedSubscript:params_key];
                if (value == nil) {
                    return nil;
                }
                if (propertyType) {
                    //对象方法
//                    Class propertyClass = NSClassFromString(propertyType);
//                    if (propertyClass) {
//                        propertyClass * a = [propertyClass mj_setKeyValues:<#(id)#>]
//                    }
//                    else{
//                        continue;
//                    }
                }
                else{
                    if (propertyName && value) {
                        [target_kvc_dict setObject:value forKey:property_key];
                    }
                }
            }
        }
        if (vcInfo.initWay == HBInitialWayStoryBoard) {
            if (vcInfo.storyBoardName != nil && vcInfo.storyBoardId != nil) {
                UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:vcInfo.storyBoardName bundle:nil];
                controller = [storyBoard instantiateViewControllerWithIdentifier:vcInfo.storyBoardId];
                if (target_kvc_dict.allKeys.count>0 && controller != nil) {
                    [controller setValuesForKeysWithDictionary:target_kvc_dict];
                }
            }
            else{
                return nil;
            }
        }
        else if(vcInfo.initWay == HBInitialWayDefault){
            controller = [[NSClassFromString(vcInfo.className) alloc]init];
            if (target_kvc_dict.allKeys.count>0 && controller != nil) {
                [controller setValuesForKeysWithDictionary:target_kvc_dict];
            }
        }
        else if (vcInfo.initWay == HBInitialWayStaticMethod){
            Class targetClass = NSClassFromString(vcInfo.factoryInitialInfo.targetClassName);
            if (targetClass==nil) {
                return nil;
            }
            controller = [HBXCallBackHander invokeMethodWithTargetClass:targetClass selectorString:vcInfo.factoryInitialInfo.selectorString arguments:vcInfo.factoryInitialInfo.paramsInfoString argumentsInfo:target_kvc_dict];
        }
        return controller;
    }
    else{
        return nil;
    }
}
- (BOOL)preferModalPresentationWithVCInfo:(HBXCallBackVCInfo *)vcInfo routeExpressionInfo:(HBXCallBackRouteExpressionInfo *)routeExpressionInfo request:(WLRRouteRequest *)request;{
    return routeExpressionInfo.isModal.boolValue;
}
-(UIViewController *)targetViewControllerWithRequest:(WLRRouteRequest *)request{
    NSString * router_expression = request.routeExpression;
    if (router_expression != nil) {
        return nil;
    }
    //根据路由正则表达式获取router_expression_info
    HBXCallBackRouteExpressionInfo * router_expression_info = [self.route_expression_info objectForKey:router_expression];
    if (router_expression_info == nil) {
        return nil;
    }
    Class impl = [self implClassWithActionName:router_expression];
    if (impl==nil) {
        return nil;
    }
    HBXCallBackVCInfo * vc_info = [self.vc_config_info objectForKey:router_expression_info.className];
    if (vc_info == nil) {
        return nil;
    }
    NSMutableDictionary * target_kvc_dict = [[NSMutableDictionary alloc]init];
    if (router_expression_info.kvcMapInfo) {
        for (NSString * key in router_expression_info.kvcMapInfo.allKeys) {
            NSString * property_key = [router_expression_info.kvcMapInfo objectForKey:key];
            
            id value = [request objectForKeyedSubscript:key];
            if (property_key && value) {
                [target_kvc_dict setObject:value forKey:property_key];
            }
        }
    }
    UIViewController * controller = nil;
    if (vc_info.initWay == HBInitialWayDefault) {
        controller = [[NSClassFromString(vc_info.className) alloc]init];
        if (target_kvc_dict.allKeys.count>0 && controller != nil) {
            [controller setValuesForKeysWithDictionary:target_kvc_dict];
        }
    }
    else if (vc_info.initWay == HBInitialWayStoryBoard){
        if (vc_info.storyBoardName != nil && vc_info.storyBoardId != nil) {
            UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:vc_info.storyBoardName bundle:nil];
            controller = [storyBoard instantiateViewControllerWithIdentifier:vc_info.storyBoardId];
            if (target_kvc_dict.allKeys.count>0 && controller != nil) {
                [controller setValuesForKeysWithDictionary:target_kvc_dict];
            }
        }
        else{
            return nil;
        }
    }
    else if (vc_info.initWay == HBInitialWayStaticMethod){
        
    }
    else{
        return nil;
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
        HBXCallBackRouteExpressionInfo * router_expression_info = [self.route_expression_info objectForKey:routeExpression];
        if (router_expression_info == nil) {
            return NO;
        }
        Class impl = [self implClassWithActionName:routeExpression];
        if (impl==nil) {
            return NO;
        }
        HBXCallBackVCInfo * vc_info = [self.vc_config_info objectForKey:router_expression_info.className];
        if (vc_info == nil) {
            return NO;
        }
        UIViewController * targetViewController = [self targetViewControllerWithVCInfo:vc_info routeExpressionInfo:router_expression_info request:request];
        if (targetViewController == nil) {
            NSLog(@"X-Call-Back:----------------------->\n Cant't find Target\n ------------INFO:-----------\n %@",request);
        }
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
#pragma mark load local config file
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
                HBXCallBackRouteExpressionInfo * expressionInfo = [[HBXCallBackRouteExpressionInfo alloc]init];
                expressionInfo.routeExpression = routeExpression;
                expressionInfo.className = className;
                expressionInfo.isModal = isModal;
                expressionInfo.kvcMapInfo = kvcMapInfo;
                NSDictionary * vc_config_info_dict = [vc_config_infos objectForKey:expressionInfo.className];
                if (vc_config_info_dict == nil) {
                    continue;
                }
                HBXCallBackVCInfo * vc_config_info  ;
                vc_config_info = [HBXCallBackVCInfo mj_objectWithKeyValues:vc_config_info_dict];
                [self.vc_config_info setObject:vc_config_info forKey:expressionInfo.className];
                [self.route_expression_info setObject:expressionInfo forKey:route_expression_key];
                [self registeModuleClass:NSClassFromString(vc_config_info.className) forActionName:expressionInfo.routeExpression];
            }
        }
    }
    else{
        NSLog(@"HBXCallBack not fount %@ config file!",pathName);
    }
}
-(void)registeModuleClass:(Class)implClass forActionName:(NSString *)actionName;{
    NSParameterAssert(implClass != nil);
    NSParameterAssert(actionName != nil);
    NSString *key = [NSString stringWithFormat:@"%@",actionName];
    NSString *value = NSStringFromClass(implClass);
    if (key.length > 0 && value.length > 0 && [actionName isKindOfClass:[NSString class]] && actionName.length>0) {
        [self.lock lock];
        [self.actionsMap addEntriesFromDictionary:@{key:value}];
        [self.lock unlock];
    }
    [self.router registerHandler:self forRoute:[NSString stringWithFormat:@"x-call-back/%@",actionName]];
}
#pragma mark -utility method
+(id)invokeMethodWithTargetClass:(Class)targetClass selectorString:(NSString *)selectorString arguments:(NSArray *)arguments argumentsInfo:(NSDictionary * )argumentsInfo{
    @try {
        SEL targetSelector = NSSelectorFromString(selectorString);
        NSMethodSignature * signature = [targetClass methodSignatureForSelector:targetSelector];
        if (signature == nil) {
            return nil;
        }
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:targetClass];
        [invocation setSelector:targetSelector];
        for (int i = 0; i<arguments.count; i++) {
            NSString * element = [arguments objectAtIndex:i];
            NSArray *propertyKeyInfoArr = [element componentsSeparatedByString:@"#"];
            NSString * propertyKeyName = propertyKeyInfoArr.firstObject;
            NSString * propertyKeyType = nil;
            if (propertyKeyInfoArr.count>1) {
                propertyKeyType = propertyKeyInfoArr.lastObject;
                if ([propertyKeyType isEqualToString:@"uint"]) {
                    NSString * propertyValue = [argumentsInfo objectForKey:propertyKeyName];
                    if ([propertyValue isKindOfClass: [NSString class]]) {
                        NSUInteger uintValue = propertyValue.integerValue;
                        [invocation setArgument:&uintValue atIndex:2+i];
                    }
                    else{
                        return nil;
                    }
                }
                else if ([propertyKeyType isEqualToString:@"s"]){
                    NSString * propertyValue = [argumentsInfo objectForKey:propertyKeyName];
                    if ([propertyValue isKindOfClass: [NSString class]]) {
                        [invocation setArgument:&propertyValue atIndex:2+i];
                    }
                    else{
                        return nil;
                    }
                }
                else{
                    return nil;
                }
            }
            else{
                id propertyvalue = [argumentsInfo objectForKey:propertyKeyName];
                [invocation setArgument:&propertyvalue atIndex:2+i];
            }
        }
        if (!strcmp(signature.methodReturnType, @encode(id))) {
            CFTypeRef result;
            [invocation invoke];
            [invocation getReturnValue:&result];
            if (result)
                CFRetain(result);
            id resultObj = (__bridge_transfer id)result;
            return resultObj;
        }
        else{
            return nil;
        }
        
    } @catch (NSException *exception) {
        return nil;
    } @finally {
        
    }
}
@end
