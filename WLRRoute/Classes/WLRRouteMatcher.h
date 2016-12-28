//
//  WLRRouteMatcher.h
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import <Foundation/Foundation.h>
@class WLRRouteRequest;
@interface WLRRouteMatcher : NSObject
@property(nonatomic,copy)NSString * routeExpressionPattern;
@property(nonatomic,copy)NSString * originalRouteExpression;
+(instancetype)matcherWithRouteExpression:(NSString *)expression;
-(WLRRouteRequest *)createRequestWithURL:(NSURL *)URL primitiveParameters:(NSDictionary *)primitiveParameters targetCallBack:(void(^)(NSError *, id responseObject))targetCallBack;
@end
