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
@property (weak, nonatomic) IBOutlet UITextField *monitorTelephoneTextField;

@end

@implementation AddMonitorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"设备添加" TextColor:[UIColor whiteColor] Font:nil];
    [self setNavigationLeftItemWithNormalImg:[UIImage imageNamed:@"arrows_left"] highlightedImg:[UIImage imageNamed:@"arrows_left"]];
    [self setNavigationRightItemWithString:@"提交"];
    self.afreshAddressBtn.layer.masksToBounds = YES;
    self.afreshAddressBtn.layer.cornerRadius = 5;
    self.afreshAddressBtn.layer.borderColor = [ColorRequest BackGroundColor].CGColor;
    self.afreshAddressBtn.layer.borderWidth = 1.0f;
    
    self.myAddressTextField.text = [LocationManager sharedManager].detailAddress;
//    self.myAddressTextField.text = @"1111";
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideSVProgressHUD];
    [LocationManager sharedManager].reverseGeocodeLocationSuccessBlock = nil;
}

- (void)rightBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];

    if ([self.myAddressTextField.text isEqualToString:@""]) {
        [self showMessageWithString:@"请定位当前地址或手动输入地址" showTime:1.0];
    } else if ([self.monitorNameTextField.text isEqualToString:@""]) {
        [self showMessageWithString:@"请输入设备编号" showTime:1.0];
    } else if ([self.monitorAccountTextField.text isEqualToString:@""]) {
        [self showMessageWithString:@"请输入设备电话号码" showTime:1.0];
    } else if ([self.monitorTelephoneTextField.text isEqualToString:@""]) {
        [self showMessageWithString:@"请输入设备所属用户账号" showTime:1.0];
    } else {
        //提交
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)afreshAddressBtnClick:(id)sender {
    [self showSVProgressHUD];
    //获取用户位置
    [[LocationManager sharedManager] currentLocation];
    [LocationManager sharedManager].reverseGeocodeLocationSuccessBlock = ^{
        self.myAddressTextField.text = [LocationManager sharedManager].detailAddress;
        [self hideSVProgressHUD];
    };
}


@end
