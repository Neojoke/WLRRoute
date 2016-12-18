//
//  WLRRouteHandler.h
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import <Foundation/Foundation.h>
@class WLRRouteRequest;
@interface WLRRouteHandler : NSObject
- (BOOL)shouldHandleWithRequest:(WLRRouteRequest *)request;
-(UIViewController *)targetViewControllerWithRequest:(WLRRouteRequest *)request;
-(UIViewController *)sourceViewControllerForTransitionWithRequest:(WLRRouteRequest *)request;
-(BOOL)transitionWithRequest:(WLRRouteRequest *)request error:(NSError *__autoreleasing *)error;
@end
