//
//  NSError+WLRError.m
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import "NSError+WLRError.h"
NSString * const WLRErrorDomain = @"com.wlrroute.error";

@implementation NSError (WLRError)
+(NSError *)WLRNotFoundError{
    return [self WLRErrorWithCode:WLRErrorNotFound msg:@"The passed URL does not match a registered route."];
}
+(NSError *)WLRTransitionError{

    return [self WLRErrorWithCode:WLRErrorHandlerTargetOrSourceViewControllerNotSpecified msg:@"TargetViewController or SourceViewController not correct"];
}
+(NSError *)WLRHandleBlockNoTeturnRequest
{
    return [self WLRErrorWithCode:WLRErrorBlockHandleNoReturnRequest msg:@"Block handle no turn WLRRouteRequest object"];
}

+(NSError *)WLRMiddlewareRaiseErrorWithMsg:(NSString *)error{
    return [self WLRErrorWithCode:WLRErrorMiddlewareRaiseError msg:[NSString stringWithFormat:@"WLRRouteMiddle raise a error:%@",error]];
}
+(NSError *)WLRErrorWithCode:(NSInteger)code msg:(NSString *)msg{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(msg, nil) };
    return [NSError errorWithDomain:WLRErrorDomain code:code userInfo:userInfo];
}
@end
