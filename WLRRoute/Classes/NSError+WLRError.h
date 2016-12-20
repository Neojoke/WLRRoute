//
//  NSError+WLRError.h
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, DPLErrorCodes) {
    
    /** The passed URL does not match a registered route. */
    WLRRouteNotFoundError = 45150,
    
    /** The matched route handler does not specify a target view controller. */
    WLRRouteHandlerTargetOrSourceViewControllerNotSpecifiedError = 45151,
    WLRRouteBlockHandleNoReturnRequestError = 45152,
    WLRRouteMiddlewareRaiseError = 45153
};
@interface NSError (WLRError)
+(NSError *)WLRNotFoundError;
+(NSError *)WLRTransitionError;
+(NSError *)WLRHandleBlockNoTeturnRequest;
+(NSError *)WLRMiddlewareRaiseErrorWithMsg:(NSString *)error;
@end
