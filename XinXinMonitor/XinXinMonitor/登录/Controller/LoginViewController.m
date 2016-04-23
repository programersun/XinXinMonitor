//
//  LoginViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/19.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTableViewCell.h"
#import "MainTabBarViewController.h"

@interface LoginViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitle:@"登录" TextColor:[UIColor whiteColor] Font:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 150;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 50;
            break;
        case 3:
            return 70 * KASAdapterSizeWidth;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellId = [LoginTableViewCell cellWithID:indexPath.row];
    LoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[LoginTableViewCell alloc] init];
    }
    
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            cell.loginBtn.layer.masksToBounds = YES;
            cell.loginBtn.layer.cornerRadius = 5;
            cell.loginBtnClickBlock = ^(){
                
                NSDictionary *dict = @{@"userid":@"1234"};
                [[UserInfoManager sharedManager] saveUserInfo:dict];
                
                MainTabBarViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
                if (vc == nil) {
                    vc = [[MainTabBarViewController alloc] init];
                }
                [[UIApplication sharedApplication].delegate window].rootViewController = vc;
            };
            break;
            
        default:
            break;
    }
    
    return cell;
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
