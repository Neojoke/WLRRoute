//
//  WLRSignHandler.m
//  WLRRoute
//
//  Created by Neo on 2016/12/18.
//  Copyright © 2016年 Neo. All rights reserved.
//

#import "WLRSignHandler.h"

@implementation WLRSignHandler
-(UIViewController *)targetViewControllerWithRequest:(WLRRouteRequest *)request{
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [story instantiateViewControllerWithIdentifier:@"WLRSignViewController"];
    return vc;
}
@end
