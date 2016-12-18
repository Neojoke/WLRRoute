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
