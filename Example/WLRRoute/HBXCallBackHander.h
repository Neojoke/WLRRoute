//
//  HBXCallBackHander.h
//  HBStockWarning
//
//  Created by Neo on 2018/6/7.
//  Copyright © 2018年 Touker. All rights reserved.
//

#import "WLRRouteHandler.h"
#import <WLRRoute/WLRRouteRequest.h>
@class WLRRouter;
typedef BOOL(^HBXCALLBACKTrainsationBlock)(UIViewController * targetViewController,UIViewController *sourceViewController,BOOL isModal,WLRRouteRequest * request);
@interface HBXCallBackHander : WLRRouteHandler

@property(nonatomic,weak)WLRRouter * router;
@property(nonatomic)BOOL enableException;
@property(nonatomic,copy)HBXCALLBACKTrainsationBlock trainsationBlock;
+(HBXCallBackHander *)handlerWithRouter:(WLRRouter *)router;
-(void)registeModuleClass:(Class)implClass forActionName:(NSString *)actionName;
-(void)loadLocalConfigWithPathName:(NSString *)pathName;
@end
