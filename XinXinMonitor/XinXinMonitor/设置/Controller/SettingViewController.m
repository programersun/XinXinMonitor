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

@interface SettingViewController () <UITableViewDelegate,UITableViewDataSource>
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
        cell.accountLabel.text = [NSString stringWithFormat:@"账号:%@",@"XXXX"];
    }
    
    if (indexPath.section == 2) {
        __weak SettingViewController *weakself = self;
        cell.logoutBtnClickBlock = ^{
            [weakself logOutBtnClick];
        };
    }
    return cell;
}

#pragma mark - UITableViewDelegate

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
