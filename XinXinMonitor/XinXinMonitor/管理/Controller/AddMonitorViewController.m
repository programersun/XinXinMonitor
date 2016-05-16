//
//  AddMonitorViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/8.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "AddMonitorViewController.h"
#import "TimeView.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface AddMonitorViewController () <UIAlertViewDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
/** 当前地址*/
@property (weak, nonatomic) IBOutlet UITextField *myAddressTextField;
/** 重新定位*/
@property (weak, nonatomic) IBOutlet UIButton *afreshAddressBtn;
/** 设备编号*/
@property (weak, nonatomic) IBOutlet UITextField *monitorNameTextField;
/** 设备所属账户*/
@property (weak, nonatomic) IBOutlet UITextField *monitorAccountTextField;
/** 设备电话*/
@property (weak, nonatomic) IBOutlet UITextField *monitorTelephoneTextField;
/** 设备类型*/
@property (weak, nonatomic) IBOutlet UITextField *monitorTypeTextField;

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
    
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    [self reverseGeocode];
//    self.myAddressTextField.text = @"1111";
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.geocodesearch.delegate = nil; // 不用时，置nil
    [self hideSVProgressHUD];
    [LocationManager sharedManager].reverseGeocodeLocationSuccessBlock = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)dealloc {
    if (self.geocodesearch != nil) {
        self.geocodesearch = nil;
    }
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
    } else if ([self.monitorTypeTextField.text isEqualToString:@""]) {
        [self showMessageWithString:@"请输入设备类型" showTime:1.0];
    } else{
        //提交
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.view endEditing:YES];
        [SVProgressHUD show];
        if ([self.myAddressTextField.text isEqualToString:[LocationManager sharedManager].detailAddress]) {
            [self addMonitor];
        } else {
            [self geocode];
        }
    }
}

- (void)addMonitor {
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,AddMonitorAPI] params:[XinXinMonitorAPI addMonitorAddress:self.myAddressTextField.text cameraCode:self.monitorNameTextField.text phone:self.monitorTelephoneTextField.text customerKey:self.monitorAccountTextField.text monitorType:self.monitorTypeTextField.text] success:^(id responseObj) {
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        NSDictionary *dic = responseObj;
        if ([[dic objectForKey:@"code"] integerValue] == 1) {
            [self showSuccessWithString:[dic objectForKey:@"message"] showTime:1.0];
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } else {
            [self showMessageWithString:[dic objectForKey:@"message"] showTime:1.0];
        }
    } failure:^(NSError *error) {
        [self showMessageWithString:@"服务器开小差了" showTime:1.0];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];

}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == 0) {
        [LocationManager sharedManager].detailAddress = result.address;
        self.myAddressTextField.text = result.address;
        [[LocationManager sharedManager] saveMyCityWithString:result.addressDetail.city];
        [[LocationManager sharedManager] saveMyDistrictWithString:result.addressDetail.district];
    }
}

- (void)reverseGeocode {
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
        pt = (CLLocationCoordinate2D){[[LocationManager sharedManager].latitude floatValue], [[LocationManager sharedManager].longitude floatValue]};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == 0) {
        [LocationManager sharedManager].latitude = [NSString stringWithFormat:@"%f",result.location.latitude];
        [LocationManager sharedManager].longitude = [NSString stringWithFormat:@"%f",result.location.longitude];
        [LocationManager sharedManager].detailAddress = result.address;
        [self addMonitor];
    }
}

- (void)geocode {
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//    geocodeSearchOption.city= _cityText.text;
    geocodeSearchOption.address = self.myAddressTextField.text;
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

- (IBAction)afreshAddressBtnClick:(id)sender {
    [self showSVProgressHUD];
    [self.view endEditing:YES];
    //获取用户位置
    [[LocationManager sharedManager] currentLocation];
    [LocationManager sharedManager].reverseGeocodeLocationSuccessBlock = ^{
        [self reverseGeocode];
        [self hideSVProgressHUD];
    };
}


@end
