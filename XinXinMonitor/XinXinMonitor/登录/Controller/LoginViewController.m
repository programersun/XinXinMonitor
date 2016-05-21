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

@interface LoginViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) NSString *userKey;
@property (nonatomic, strong) NSString *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitle:@"登录" TextColor:[UIColor whiteColor] Font:nil];
    self.userKey = @"";
    self.password = @"";
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
            return 70;
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
            cell.accountText.tag = 0;
            cell.accountText.delegate = self;
            [cell.accountText addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            break;
        case 2:
            cell.passwordText.tag = 1;
            cell.passwordText.delegate = self;
            [cell.passwordText addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            break;
        case 3:
        {
            cell.loginBtn.layer.masksToBounds = YES;
            cell.loginBtn.layer.cornerRadius = 5;
            __weak LoginTableViewCell *weakcell = cell;
            cell.loginBtnClickBlock = ^(){
                if ([self.userKey isEqualToString:@""]) {
                    [self showMessageWithString:@"请输入账号" showTime:1.0];
                } else if ([self.password isEqualToString:@""]) {
                    [self showMessageWithString:@"请输入密码" showTime:1.0];
                } else {
                    weakcell.loginBtn.enabled = NO;
                    [self.view endEditing:YES];
                    [self showSVProgressHUD];
                    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,LoginAPI] params:[XinXinMonitorAPI loginWithUserKey:self.userKey password:self.password] success:^(id responseObj) {
                        NSDictionary *dict = responseObj;
                        if ([[dict objectForKey:@"code"] integerValue] == 1) {
                            [[UserInfoManager sharedManager] saveUserInfo:[dict objectForKey:@"content"]];
                            [self setAliasWithSring:[UserInfoManager sharedManager].userID];
                            MainTabBarViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
                            if (vc == nil) {
                                vc = [[MainTabBarViewController alloc] init];
                            }
                            [[UIApplication sharedApplication].delegate window].rootViewController = vc;
                        } else {
                            weakcell.loginBtn.enabled = YES;
                            [self showMessageWithString:[dict objectForKey:@"message"] showTime:1.0];
                        }
                        
                    } failure:^(NSError *error) {
                        weakcell.loginBtn.enabled = YES;
                        [self showMessageWithString:@"服务器开小差了" showTime:1.0];
                    }];
                }
            };
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)textFieldWithText:(UITextField *)textField  {
    switch (textField.tag) {
        case 0:
            self.userKey = textField.text;
            break;
        case 1:
            self.password = textField.text;
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    [textField resignFirstResponder];
    return YES;
}

- (void)setAliasWithSring:(NSString *)userString {
    userString = [userString stringByReplacingOccurrencesOfString:@"." withString:@""];
    [JPUSHService setAlias:[userString stringByReplacingOccurrencesOfString:@" " withString:@""] callbackSelector:nil object:nil];
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
