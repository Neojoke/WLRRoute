//
//  WLRSignViewController.m
//  WLRRoute
//
//  Created by Neo on 2016/12/18.
//  Copyright © 2016年 Neo. All rights reserved.
//

#import "WLRSignViewController.h"
#import <WLRRoute/WLRRoute.h>
@implementation Person
@end
@interface WLRSignViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Phone;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation WLRSignViewController
+(WLRSignViewController *)vcwith:(Person *)person state:(NSInteger)state{
    WLRSignViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WLRSignViewController"];
    vc.title_name = person.name;
    vc.person = person;
    vc.state = state;
    return vc;
}
#pragma mark -Module Protocol impl
+(BOOL)handleRequest:(WLRRouteRequest *)request actionName:(NSString *)actionName completionHandler:(WLRRouteCompletionHandler)completionHandler{
    UIViewController * controller = [self targetViewControllerWithRequest:request actionName:actionName completionHandler:completionHandler];
    if (!controller) {
        return NO;
    }
    controller.wlr_request = request;
    [self transitionWithTargetViewController:controller request:request actionName:actionName];
    return YES;
}
+(UIViewController *)targetViewControllerWithRequest:(WLRRouteRequest *)request actionName:(NSString *)actionName completionHandler:(WLRRouteCompletionHandler)completionHandler{
    UIViewController * vc = [self signViewControllerWithPhone:request[@"phone"]];
    return vc;
}
+(UIViewController *)signViewControllerWithPhone:(NSString *)phone{
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WLRSignViewController * vc = [story instantiateViewControllerWithIdentifier:@"WLRSignViewController"];
    vc.Phone.text = phone;
    return vc;
}
+(void)transitionWithTargetViewController:(UIViewController *)ViewController request:(WLRRouteRequest *)request actionName:(NSString *)actionName{
    UIViewController * sourceViewController =[UIApplication sharedApplication].windows[0].rootViewController;
    if ([sourceViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController * nav = (UINavigationController *)sourceViewController;
        [nav pushViewController:ViewController animated:YES];
    }
}
- (IBAction)go:(UIButton *)sender {
    
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.Phone.text = self.wlr_request[@"phone"];
    if (self.title_name) {
        self.title = self.title_name;
    }
    // Do any additional setup after loading the view.
}
-(void)viewDidDisappear:(BOOL)animated{
    
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
