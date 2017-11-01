//
//  WLRRouteMiddlewareProtocol.h
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import <Foundation/Foundation.h>
@class WLRRouteRequest;
@protocol WLRRouteMiddleware <NSObject>


/**
 middleware handle a request, if middleware can handle this request, should return a response object, middleware could modify primitiveRequest inner, router will check and capture error and return dictionary, if return nil, router will transfer this request from current middleware to other

 @param primitiveRequest primitive request, middleware can modify this request
 @param error if middleware can handle this request and raise a error, router will handle this request with error and no long transfer.
 @return if middleware can handle this request and return a responseObject,
 router will handle this request with responseObject and no long transfer.
 */
-(NSDictionary *)middlewareHandleRequestWith:(WLRRouteRequest *__autoreleasing *)primitiveRequest error:(NSError *__autoreleasing *)error;
@end
