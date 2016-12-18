//
//  NSError+WLRError.m
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import "NSError+WLRError.h"
NSString * const WLRErrorDomain = @"com.usebutton.deeplink.error";

@implementation NSError (WLRError)
+(NSError *)WLRNotFoundError{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"The passed URL does not match a registered route.", nil) };
    return [NSError errorWithDomain:WLRErrorDomain code:WLRRouteNotFoundError userInfo:userInfo];
}
+(NSError *)WLRTransitionError{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"TargetViewController or SourceViewController not correct", nil) };
    return [NSError errorWithDomain:WLRErrorDomain code:WLRRouteHandlerTargetOrSourceViewControllerNotSpecifiedError userInfo:userInfo];
}
@end
