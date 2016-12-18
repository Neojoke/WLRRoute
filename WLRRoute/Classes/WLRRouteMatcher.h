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
+(instancetype)matcherWithRouteExpression:(NSString *)expression;
-(WLRRouteRequest *)createRequestWithURL:(NSURL *)URL primitiveParameters:(NSDictionary *)primitiveParameters targetCallBack:(void(^)(NSError *, id responseObject))targetCallBack;
@end
