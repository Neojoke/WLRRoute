//
//  WLRSignViewController.m
//  WLRRoute
//
//  Created by Neo on 2016/12/18.
//  Copyright © 2016年 Neo. All rights reserved.
//

#import "WLRSignViewController.h"
#import <WLRRoute/WLRRoute.h>
@interface WLRSignViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Phone;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation WLRSignViewController
- (IBAction)go:(UIButton *)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Phone.text = self.wlr_request[@"phone"];
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
