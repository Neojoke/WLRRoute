//
//  HBConfigRoutingHandler.h
//  WLRRoute_Example
//
//  Created by Neo on 2018/10/21.
//  Copyright © 2018 Neo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WLRRoute/WLRRouteHandler.h>
typedef NS_ENUM(NSUInteger, HBRoutingConfigVCInitType) {
    HBRoutingConfigVCInitTypeDefault,
    HBRoutingConfigVCInitTypeStoryBoard,
    HBRoutingConfigVCInitTypeStaticMethod
};
@interface HBSeletorArgType : NSObject
@property(nonatomic,copy)NSString * argName;
@property(nonatomic,copy)NSString * argClassName;
@end
@interface HBRoutingConfigInfo:NSObject
@property(nonatomic,copy)NSString * routeExpression;
@property(nonatomic)BOOL isModal;
@property(nonatomic)HBRoutingConfigVCInitType initWay;
@property(nonatomic,copy)NSString * className;
//HBRoutingConfigVCInitTypeStoryBoard
@property(nonatomic,copy)NSString * storyBoardName;
@property(nonatomic,copy)NSString * storyBoardId;
//HBRoutingConfigVCInitTypeStaticMethod
@property(nonatomic,copy)NSString * targetClassName;
@property(nonatomic,copy)NSString * selectorString;
@property(nonatomic,copy)NSArray<HBSeletorArgType*> * selectorArginfos;
@end
@class WLRRouter;
NS_ASSUME_NONNULL_BEGIN
typedef BOOL(^HBConfigRoutingTrainsationBlock)(UIViewController * targetViewController,UIViewController *sourceViewController,BOOL isModal,WLRRouteRequest * request);

@interface HBConfigRoutingHandler  : WLRRouteHandler
@property(nonatomic,strong)NSMutableDictionary<NSString *,HBRoutingConfigInfo*> * configInfoDict;
@property(nonatomic,copy)HBConfigRoutingTrainsationBlock trainsationBlock;
@property(nonatomic,weak)WLRRouter * router;
+(HBConfigRoutingHandler *)handlerWithRouter:(WLRRouter *)router configInfoDict:(NSDictionary<NSString *,HBRoutingConfigInfo*>*)configInfoDict;
@end

NS_ASSUME_NONNULL_END
