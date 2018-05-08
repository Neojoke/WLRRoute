//
//  WLRRouter.m
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import "WLRRouter.h"
#import <objc/runtime.h>
#import "WLRRouteHandler.h"
#import "WLRRouteMatcher.h"
#import "WLRRouteRequest.h"
#import "NSError+WLRError.h"
@interface WLRRouter()
@property(nonatomic,strong)NSMutableDictionary * routeMatchers;
@property(nonatomic,strong)NSMutableDictionary * routeHandles;
@property(nonatomic,strong)NSMutableDictionary * routeblocks;
@property(nonatomic,strong)NSHashTable * middlewares;
@end
@implementation WLRRouter
-(NSHashTable *)middlewares{
    if (!_middlewares) {
        _middlewares = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return _middlewares;
}
-(void)addMiddleware:(id<WLRRouteMiddleware>)middleware{
    if (middleware) {
        [self.middlewares addObject:middleware];
    }
}
-(void)removeMiddleware:(id<WLRRouteMiddleware>)middleware{
    if ([self.middlewares containsObject:middleware]) {
        [self.middlewares removeObject:middleware];
    }
}
-(instancetype)init{
    if (self = [super init]) {
        _routeblocks = [NSMutableDictionary dictionary];
        _routeHandles = [NSMutableDictionary dictionary];
        _routeMatchers = [NSMutableDictionary dictionary];
    }
    return self;
}
-(void)registerBlock:(WLRRouteRequest *(^)(WLRRouteRequest *))routeHandlerBlock forRoute:(NSString *)route{
    if (routeHandlerBlock && [route length]) {
        [self.routeMatchers setObject:[WLRRouteMatcher matcherWithRouteExpression:route] forKey:route];
        [self.routeHandles removeObjectForKey:route];
        self.routeblocks[route] = routeHandlerBlock;
    }
}
-(void)registerHandler:(WLRRouteHandler *)handler forRoute:(NSString *)route{
    if (handler && [route length]) {
        [self.routeMatchers setObject:[WLRRouteMatcher matcherWithRouteExpression:route] forKey:route];
        [self.routeblocks removeObjectForKey:route];
        self.routeHandles[route] = handler;
    }
}
-(id)objectForKeyedSubscript:(NSString *)key{
    NSString * route = (NSString *)key;
    id obj = nil;
    if ([route isKindOfClass:[NSString class]] && [route length]) {
        obj = self.routeHandles[route];
        if (obj == nil) {
            obj = self.routeblocks[route];
        }
    }
    return obj;
}
-(void)setObject:(id)obj forKeyedSubscript:(NSString *)key{
    NSString * route = (NSString *)key;
    if (!([route isKindOfClass:[NSString class]] && [route length])) {
        return;
    }
    if (!obj) {
        [self.routeblocks removeObjectForKey:route];
        [self.routeHandles removeObjectForKey:route];
        [self.routeMatchers removeObjectForKey:route];
    }
    else if ([obj isKindOfClass:NSClassFromString(@"NSBlock")]){
        [self registerBlock:obj forRoute:route];
    }
    else if ([obj isKindOfClass:[WLRRouteHandler class]]){
        [self registerHandler:obj forRoute:route];
    }
}
-(BOOL)canHandleWithURL:(NSURL *)url{
    for (NSString * route in self.routeMatchers.allKeys) {
        WLRRouteMatcher * matcher = [self.routeMatchers objectForKey:route];
        WLRRouteRequest * request = [matcher createRequestWithURL:url primitiveParameters:nil targetCallBack:nil];
        if (request) {
            return YES;
        }
    }
    return NO;
}
-(BOOL)handleURL:(NSURL *)URL primitiveParameters:(NSDictionary *)primitiveParameters targetCallBack:(void(^)(NSError *error, id responseObject))targetCallBack withCompletionBlock:(void(^)(BOOL handled, NSError *error))completionBlock{
    if (!URL) {
        return NO;
    }
    NSError * error;
    WLRRouteRequest * request;
    __block BOOL isHandled = NO;
    for (NSString * route in self.routeMatchers.allKeys) {
        WLRRouteMatcher * matcher = [self.routeMatchers objectForKey:route];
        request = [matcher createRequestWithURL:URL primitiveParameters:primitiveParameters targetCallBack:targetCallBack];
        if (request) {
            NSDictionary * responseObject;
            for (id<WLRRouteMiddleware>middleware in self.middlewares){
                if (middleware != NULL &&[middleware respondsToSelector:@selector(middlewareHandleRequestWith:error:)]) {
                    WLRRouteRequest * copyRequest = [request copy];
                    responseObject = [middleware middlewareHandleRequestWith:copyRequest error:&error];
                    if ((responseObject != nil )||(error != nil)) {
                        isHandled = YES;
                        if (request.targetCallBack) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                request.targetCallBack(error,responseObject);
                            });
                        }
                        break;
                    }
                }
            }
            if (isHandled == NO) {
                isHandled = [self handleRouteExpression:route withRequest:request error:&error];
            }
            break;
        }
    }
    if (!request) {
        error = [NSError WLRNotFoundError];
    }
    [self completeRouteWithSuccess:isHandled error:error completionHandler:completionBlock];
    return isHandled;
}
-(BOOL)handleRouteExpression:(NSString *)routeExpression withRequest:(WLRRouteRequest *)request error:(NSError *__autoreleasing *)error {
    id handler = self[routeExpression];
    if ([handler isKindOfClass:NSClassFromString(@"NSBlock")]) {
        WLRRouteRequest *(^blcok)(WLRRouteRequest *) = handler;
        WLRRouteRequest * backRequest = blcok(request);
        if (backRequest.isConsumed==NO) {
            if (backRequest) {
                backRequest.isConsumed = YES;
                if (backRequest.targetCallBack) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        backRequest.targetCallBack(nil,nil);
                    });
                }
            }
            else{
                request.isConsumed = YES;
                if (request.targetCallBack) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        backRequest.targetCallBack([NSError WLRHandleBlockNoTeturnRequest],nil);
                    });
                }
            }
        }
        return YES;
    }
    else if ([handler isKindOfClass:[WLRRouteHandler class]]){
        WLRRouteHandler * rHandler = (WLRRouteHandler *)handler;
        if (![rHandler shouldHandleWithRequest:request]) {
            return NO;
        }
        return [rHandler handleRequest:request error:error];
    }
    return YES;
}
- (void)completeRouteWithSuccess:(BOOL)handled error:(NSError *)error completionHandler:(void(^)(BOOL handled, NSError *error))completionHandler {
    if (completionHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(handled, error);
        });
    }
}
@end
