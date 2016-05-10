//
//  AddMonitorViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/8.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "AddMonitorViewController.h"
#import "TimeView.h"

@interface AddMonitorViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *myAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *afreshAddressBtn;
@property (weak, nonatomic) IBOutlet UITextField *monitorNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *monitorAccountTextField;

@end

@implementation AddMonitorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"管理添加" TextColor:[UIColor whiteColor] Font:nil];
    [self setNavigationLeftItemWithNormalImg:[UIImage imageNamed:@"arrows_left"] highlightedImg:[UIImage imageNamed:@"arrows_left"]];
    [self setNavigationRightItemWithString:@"提交"];
    self.afreshAddressBtn.layer.masksToBounds = YES;
    self.afreshAddressBtn.layer.cornerRadius = 5;
    self.afreshAddressBtn.layer.borderColor = [ColorRequest BackGroundColor].CGColor;
    self.afreshAddressBtn.layer.borderWidth = 1.0f;
    
    // Do any additional setup after loading the view.
}

- (void)rightBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    //提交
    if ([self.myAddressTextField.text isEqualToString:@""]) {
        
    }
}

- (IBAction)afreshAddressBtnClick:(id)sender {
    //获取用户位置
    [[LocationManager sharedManager] currentLocation];
}


@end
