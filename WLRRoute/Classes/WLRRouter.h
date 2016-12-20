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

@interface WLRRouter : NSObject
-(void)registerBlock:(WLRRouteRequest *(^)(WLRRouteRequest * request))routeHandlerBlock forRoute:(NSString *)route;
-(void)registerHandler:(WLRRouteHandler *)handler forRoute:(NSString *)route;
-(BOOL)canHandleWithURL:(NSURL *)url;
-(void)setObject:(id)obj forKeyedSubscript:(NSString *)key;
-(id)objectForKeyedSubscript:(NSString *)key;
-(BOOL)handleURL:(NSURL *)URL primitiveParameters:(NSDictionary *)primitiveParameters targetCallBack:(void(^)(NSError *, id responseObject))targetCallBack withCompletionBlock:(void(^)(BOOL handled, NSError *error))completionBlock;
-(void)addMiddleware:(id<WLRRouteMiddleware>)middleware;
-(void)removeMiddleware:(id<WLRRouteMiddleware>)middleware;
@end
