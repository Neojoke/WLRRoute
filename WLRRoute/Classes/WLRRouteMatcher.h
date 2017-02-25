//
//  WLRRouteMatcher.h
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import <Foundation/Foundation.h>
@class WLRRouteRequest;
/**
 This object create a route WLRRouteRequest object with url matched string,it store the routeExpressionPattern and originalRouteExpression.
 该对象会根据url匹配表达式生成一个WLRRouteRequest路由请求对象，如果为nil则说明不匹配，如果不为nil则说明该url可以匹配.
 */
@interface WLRRouteMatcher : NSObject
/**
    a url matched regex pattern string.
 */
@property(nonatomic,copy)NSString * routeExpressionPattern;
/**
    original route url matched pattern string
 */
@property(nonatomic,copy)NSString * originalRouteExpression;
+(instancetype)matcherWithRouteExpression:(NSString *)expression;
/**
    If a NSURL object matched with routeExpressionPattern,return a WLRRouteRequest object or,otherwise return nil.

 @param URL a request url string.
 @param primitiveParameters some primitive parameters like UIImage object and so on.
 @param targetCallBack if complete handle or complete block progress,it will call targetCallBack.
 @return a WLRRouteRequest request object.
 */
-(WLRRouteRequest *)createRequestWithURL:(NSURL *)URL primitiveParameters:(NSDictionary *)primitiveParameters targetCallBack:(void(^)(NSError *, id responseObject))targetCallBack;
@end
