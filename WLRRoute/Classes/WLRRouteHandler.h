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
-(BOOL)handleRequest:(WLRRouteRequest *)request error:(NSError *__autoreleasing *)error;
-(BOOL)transitionWithWithRequest:(WLRRouteRequest *)request sourceViewController:(UIViewController *)sourceViewController targetViewController:(UIViewController *)targetViewController isPreferModal:(BOOL)isPreferModal error:(NSError *__autoreleasing *)error;
- (BOOL)preferModalPresentationWithRequest:(WLRRouteRequest *)request;
@end
