//
//  SettingViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/14.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"设置" TextColor:[UIColor whiteColor] Font:nil];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn addTarget:self action:@selector(logOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 退出
- (void)logOutBtnClick {
    
    [[UserInfoManager sharedManager] clearUserInfo];
    LoginViewController *vc = [[UIStoryboard storyboardWithName:@"LoginViewStoryboard" bundle:nil] instantiateInitialViewController];
    if (vc == nil) {
        vc = [[LoginViewController alloc] init];
    }
    [[UIApplication sharedApplication].delegate window].rootViewController = vc;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
