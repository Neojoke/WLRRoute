//
//  UIViewController+WLRRoute.h
//  Pods
//
//  Created by Neo on 2016/12/16.
//
//

#import <UIKit/UIKit.h>
@class WLRRouteRequest;
@interface UIViewController (WLRRoute)
@property(nonatomic,strong)WLRRouteRequest * wlr_request;
@end
