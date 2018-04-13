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
@interface HBXCALLBACKHandler()
@property (nonatomic, strong) NSMutableDictionary *allModuleDict;
@property(nonatomic,strong)NSMutableDictionary * actionsMap;
@property (nonatomic, strong) NSRecursiveLock *lock;
@end
@implementation HBXCALLBACKHandler
-(NSMutableDictionary *)actionsMap{
    if (!_actionsMap) {
        _actionsMap = [NSMutableDictionary dictionary];
    }
    return _actionsMap;
}
- (NSMutableDictionary *)allModuleDict
{
    if (!_allModuleDict) {
        _allModuleDict = [NSMutableDictionary dictionary];
    }
    return _allModuleDict;
}
- (NSDictionary *)moduleDict{
    [self.lock lock];
    NSDictionary *dict = [self.allModuleDict copy];
    [self.lock unlock];
    return dict;
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
-(UIViewController *)targetViewControllerWithRequest:(WLRRouteRequest *)request{
    
    return [[NSClassFromString(@"HBTestViewController") alloc]init];
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

- (BOOL)preferModalPresentationWithRequest:(WLRRouteRequest *)request;{
    return NO;
}
-(void)registeModuleProtocol:(Protocol *)moduleProtocol implClass:(Class)implClass forActionName:(NSString *)actionName;{
    NSParameterAssert(moduleProtocol != nil);
    NSParameterAssert(implClass != nil);
    NSParameterAssert(actionName != nil);
    if (![implClass conformsToProtocol:moduleProtocol]) {
        if (self.enableException) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ module does not comply with %@ protocol", NSStringFromClass(implClass), NSStringFromProtocol(moduleProtocol)] userInfo:nil];
        }
        return;
    }
    
    if ([self checkValidModuleProtocol:moduleProtocol actionName:actionName]) {
        if (self.enableException) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ protocol has been registed", NSStringFromProtocol(moduleProtocol)] userInfo:nil];
        }
        return;
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@",actionName,NSStringFromProtocol(moduleProtocol)];
    NSString *value = NSStringFromClass(implClass);
    
    if (key.length > 0 && value.length > 0 && [actionName isKindOfClass:[NSString class]] && actionName.length>0) {
        [self.lock lock];
        [self.allModuleDict addEntriesFromDictionary:@{key:value}];
        [self.actionsMap addEntriesFromDictionary:@{actionName:key}];
        [self.lock unlock];
    }
}
- (BOOL)checkValidModuleProtocol:(Protocol *)moduleProtocol actionName:(NSString *)actionName
{
    NSString * action_protocol = [NSString stringWithFormat:@"%@_%@",actionName,NSStringFromProtocol(moduleProtocol)];
    NSString *moduleImpl = [[self moduleDict] objectForKey:action_protocol];
    if (moduleImpl.length > 0) {
        return YES;
    }
    return NO;
}
-(BOOL)handleRequest:(WLRRouteRequest *)request error:(NSError *__autoreleasing *)error{
    NSLog(@"%@",request.queryParameters);
    NSString * x_success =request.queryParameters[@"x-success"];
    NSString * x_error = request.queryParameters[@"x-error"];
    NSURL * x_error_url = [NSURL URLWithString:x_error];
    NSURL * x_success_url = [NSURL URLWithString:x_success];
    NSString * actionName = request.URL.path;
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
    Class impl = [self implClassWithActionName:actionName];
    if (impl == nil) {
        *error = [NSError WLRHandleRequestErrorWithMessage:[NSString stringWithFormat:@"not found module with actionName:%@",actionName]];
        return NO;
    }
    BOOL isHandle = [impl handleRequest:request actionName:actionName completionHandler:callBack];
    return isHandle;
}
-(Class)implClassWithActionName:(NSString *)actionName{
    NSString * key = [self.actionsMap objectForKey:actionName];
    if (!key) {
        return nil;
    }
    NSString * implClassString = [[self moduleDict] objectForKey:key];
    if (implClassString.length>0) {
        return NSClassFromString(implClassString);
    }
    else{
        return nil;
    }
}
@end
