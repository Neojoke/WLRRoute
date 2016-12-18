//
//  WLRAppDelegate.h
//  WLRRoute
//
//  Created by Neo on 12/18/2016.
//  Copyright (c) 2016 Neo. All rights reserved.
//

@import UIKit;
@class WLRRouter;
@interface WLRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)WLRRouter * router;
@end
