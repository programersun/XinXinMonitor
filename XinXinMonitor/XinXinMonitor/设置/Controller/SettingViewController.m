//
//  SettingViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/14.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "SettingTableViewCell.h"
#import "SDImageCache.h"

@interface SettingViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSString *_clearCacheName;
}
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"设置" TextColor:[UIColor whiteColor] Font:nil];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.settingTableView reloadData];
}

#pragma mark - 清理图片缓存
- (void)clearTmpPics {
    _clearCacheName = 0;
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [self.settingTableView reloadData];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

-  (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 71 * KASAdapterSizeHeight;
            break;
            
        default:
            return 44 * KASAdapterSizeHeight;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 10;
            break;
        case 1:
            return 10;
            break;
            
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellId;
    
    switch (indexPath.section) {
        case 0:
        {
            cellId = [SettingTableViewCell cellWithID:0];
        }
            break;
        case 1:
        {
            cellId = [SettingTableViewCell cellWithID:indexPath.row + 1];
        }
            break;
        case 2:
        {
            cellId = [SettingTableViewCell cellWithID:4];
        }
            break;
            
        default:
            break;
    }
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[SettingTableViewCell alloc] init];
    }
    
    if (indexPath.section == 0) {
        cell.accountLabel.text = [NSString stringWithFormat:@"账号:%@",[UserInfoManager sharedManager].userName];
    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        float tmpSize = [[SDImageCache sharedImageCache] getSize];
        _clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize/1024/1024] : [NSString stringWithFormat:@"%.2fK",tmpSize];
        cell.clearLabel.text = _clearCacheName;
    }
    
    if (indexPath.section == 2) {
        cell.logoutBtnClickBlock = ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1002;
            [alert show];
        };
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //修改密码
                }
                    break;
                case 1:
                {
                    //关于我们
                }
                    break;
                case 2:
                {
                    //清理缓存
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要清除缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag = 1001;
                    [alert show];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
            
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 1001) {
            [self clearTmpPics];
        }
        if (alertView.tag == 1002) {
            [self logOutBtnClick];
        }
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
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
