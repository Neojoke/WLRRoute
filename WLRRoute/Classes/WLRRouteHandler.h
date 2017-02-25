//
//  WLRRouteHandler.h
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import <Foundation/Foundation.h>
@class WLRRouteRequest;
/**
 This is a handler object, if a WLRRouteRequest object matched, WLRRouter object will invoke shouldHandleWithRequest、handleRequest method and transitionWithWithRequest method,you can overwrite some method to complete viewcontroller transition.
 WLRRouteHandler对象与WLRRouteMatcher对象相对应，如果一个WLRRouteRequest对象匹配到该handler对象，则WLRRouter将触发 handleRequest 方法和transitionWithWithRequest方法，完成一次视图控制器的转场.
 */
@interface WLRRouteHandler : NSObject
- (BOOL)shouldHandleWithRequest:(WLRRouteRequest *)request;
-(UIViewController *)targetViewControllerWithRequest:(WLRRouteRequest *)request;
-(UIViewController *)sourceViewControllerForTransitionWithRequest:(WLRRouteRequest *)request;
-(BOOL)handleRequest:(WLRRouteRequest *)request error:(NSError *__autoreleasing *)error;
-(BOOL)transitionWithWithRequest:(WLRRouteRequest *)request sourceViewController:(UIViewController *)sourceViewController targetViewController:(UIViewController *)targetViewController isPreferModal:(BOOL)isPreferModal error:(NSError *__autoreleasing *)error;
- (BOOL)preferModalPresentationWithRequest:(WLRRouteRequest *)request;
@end
