//
//  WLRRouter.h
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import <Foundation/Foundation.h>
#import "WLRRouteMiddlewareProtocol.h"
@class WLRRouteRequest;
@class WLRRouteHandler;

/**
 Main route object,it can register a route pattern for a handler or block,manage middlewares,provide Subscription.
 路由对象实体，提供注册route表达式和对应handler、block功能，提供中间件注册，提供下标访问的快捷方法
 */
@interface WLRRouter : NSObject

/**
 注册一个route表达式并与一个block处理相关联
 
 @param routeHandlerBlock block用以处理匹配route表达式的url的请求
 @param route url的路由表达式，支持正则表达式的分组，例如app://login/:phone({0,9+})是一个表达式，:phone代表该路径值对应的key,可以在WLRRouteRequest对象中的routeParameters中获取
 */
-(void)registerBlock:(WLRRouteRequest *(^)(WLRRouteRequest * request))routeHandlerBlock forRoute:(NSString *)route;
/**
 注册一个route表达式并与一个block处理相关联
 
 @param routeHandlerBlock handler对象用以处理匹配route表达式的url的请求
 @param route url的路由表达式，支持正则表达式的分组，例如app://login/:phone({0,9+})是一个表达式，:phone代表该路径值对应的key,可以在WLRRouteRequest对象中的routeParameters中获取
 */
-(void)registerHandler:(WLRRouteHandler *)handler forRoute:(NSString *)route;

/**
 检测url是否能够被处理，不包含中间件的检查

 @param url 请求的url
 @return 是否可以handle
 */
-(BOOL)canHandleWithURL:(NSURL *)url;
-(void)setObject:(id)obj forKeyedSubscript:(NSString *)key;
-(id)objectForKeyedSubscript:(NSString *)key;

/**
 处理url请求

 @param URL 调用的url
 @param primitiveParameters 携带的原生对象
 @param targetCallBack 传给目标对象的回调block
 @param completionBlock 完成路由中转的block
 @return 是否能够handle
 */
-(BOOL)handleURL:(NSURL *)URL primitiveParameters:(NSDictionary *)primitiveParameters targetCallBack:(void(^)(NSError *, id responseObject))targetCallBack withCompletionBlock:(void(^)(BOOL handled, NSError *error))completionBlock;
-(void)addMiddleware:(id<WLRRouteMiddleware>)middleware;
-(void)removeMiddleware:(id<WLRRouteMiddleware>)middleware;
@end
