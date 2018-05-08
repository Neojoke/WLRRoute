//
//  WLRUserViewController.m
//  WLRRoute
//
//  Created by Neo on 2016/12/18.
//  Copyright © 2016年 Neo. All rights reserved.
//

#import "WLRUserViewController.h"
#import <WLRRoute/WLRRoute.h>
@interface WLRUserViewController ()

@property (weak, nonatomic) IBOutlet UILabel *user;

@end

@implementation WLRUserViewController
+(BOOL)handleRequest:(WLRRouteRequest *)request actionName:(NSString *)actionName completionHandler:(WLRRouteCompletionHandler)completionHandler{
    //1.获取目标控制器
    UIViewController * controller = [self targetViewControllerWithRequest:request actionName:actionName completionHandler:completionHandler];
    if (!controller) {
        return NO;
    }
    //2.传递给控制器request对象
    controller.wlr_request = request;
    //3.进行转场操作
    [self transitionWithTargetViewController:controller request:request actionName:actionName];
    return YES;
}
//如何获取控制器
+(UIViewController *)targetViewControllerWithRequest:(WLRRouteRequest *)request actionName:(NSString *)actionName completionHandler:(WLRRouteCompletionHandler)completionHandler{
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [story instantiateViewControllerWithIdentifier:@"WLRUserViewController"];
    return vc;
}
//获取目标控制器以后如何转场
+(void)transitionWithTargetViewController:(UIViewController *)ViewController request:(WLRRouteRequest *)request actionName:(NSString *)actionName{
    UIViewController * sourceViewController =[UIApplication sharedApplication].windows[0].rootViewController;
    if ([sourceViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController * nav = (UINavigationController *)sourceViewController;
        [nav pushViewController:ViewController animated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * user = self.wlr_request[@"user"];
    self.user.text = user;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
