//
//  WLRSignViewController.h
//  WLRRoute
//
//  Created by Neo on 2016/12/18.
//  Copyright © 2016年 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBXCALLBACKHandler.h"
//@protocol HBSignModuleProtocol<HBModuleProtocol>
//+(UIViewController *)signViewControllerWithPhone:(NSString *)phone;
//@end
@interface Person:NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,strong)NSNumber * age;
@end
@interface WLRSignViewController : UIViewController
@property(nonatomic,copy)NSString * title_name;
@property(nonatomic,strong)Person * person;
@property(nonatomic)NSInteger state;
+(WLRSignViewController *)vcwith:(Person*)person state:(NSInteger)state;

@end
