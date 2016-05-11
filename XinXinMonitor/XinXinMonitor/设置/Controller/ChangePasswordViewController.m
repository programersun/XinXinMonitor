//
//  ChangePasswordViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/10.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *currentPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *changePassword;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"修改密码" TextColor:[UIColor whiteColor] Font:nil];
    [self setNavigationLeftItemWithNormalImg:[UIImage imageNamed:@"arrows_left"] highlightedImg:[UIImage imageNamed:@"arrows_left"]];
    [self setNavigationRightItemWithString:@"提交"];
    // Do any additional setup after loading the view.
}

- (void)rightBtnClick:(UIButton *)sender {
    
    if ([self.currentPassword.text isEqualToString:@""]) {
        [self showMessageWithString:@"请输入当前密码" showTime:1.0];
    } else if ([self.changePassword.text isEqualToString:@""]) {
        [self showMessageWithString:@"请输入新密码" showTime:1.0];
    } else if (self.changePassword.text.length < 6) {
        [self showMessageWithString:@"密码不能少于6位" showTime:1.0];
    } else if ([self.currentPassword.text isEqualToString:self.changePassword.text]) {
        [self showMessageWithString:@"新密码不能与当前密码相同" showTime:1.0];
    } else if ([self.confirmPassword.text isEqualToString:@""]) {
        [self showMessageWithString:@"请输入确认密码" showTime:1.0];
    } else if (![self.confirmPassword.text isEqualToString:self.changePassword.text]) {
        [self showMessageWithString:@"新密码与确认密码不同" showTime:1.0];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
