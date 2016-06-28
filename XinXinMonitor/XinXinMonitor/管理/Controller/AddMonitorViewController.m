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
#import "ChooseMonitorTypeView.h"
#import "TimePickerView.h"
#import "ChooseAddressInMapViewController.h"

@interface AddMonitorViewController () <UIAlertViewDelegate,UITextFieldDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
/** 当前地址*/
@property (weak, nonatomic) IBOutlet UITextField *myAddressTextField;
/** 重新定位*/
@property (weak, nonatomic) IBOutlet UIButton *afreshAddressBtn;
/** 设备编号*/
@property (weak, nonatomic) IBOutlet UITextField *monitorNameTextField;
/** 设备所属账户*/
@property (weak, nonatomic) IBOutlet UILabel *monitorAccountLabel;
@property (weak, nonatomic) IBOutlet UIButton *monitorAccountBtn;
/** 设备电话*/
@property (weak, nonatomic) IBOutlet UITextField *monitorTelephoneTextField;
/** 设备类型*/
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UILabel *monitorTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *monitorTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *strikeTimeTextField;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;

@property (nonatomic, strong) UIView *chooseBackgroundView;
@property (nonatomic, strong) ChooseMonitorTypeView *chooseMonitorTypeView;
@property (nonatomic, strong) ChooseMonitorTypeView *chooseMonitorAccountView;
@property (nonatomic, strong) NSMutableArray *monitorTypeArray;
@property (nonatomic, strong) NSMutableArray *monitorAccountArray;
@property (nonatomic, strong) NSString *monitorType;
@property (nonatomic, strong) NSString *monitorTypeString;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *accountString;
@property (nonatomic, strong) NSString *cameraTime;
@property (nonatomic, strong) NSString *strikeTime; //离线时间
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *districtName;

@end

@implementation AddMonitorViewController

- (NSMutableArray *)monitorTypeArray {
    if (!_monitorTypeArray) {
        _monitorTypeArray = [NSMutableArray array];
    }
    return _monitorTypeArray;
}

- (NSMutableArray *)monitorAccountArray {
    if (!_monitorAccountArray) {
        _monitorAccountArray = [NSMutableArray array];
    }
    return _monitorAccountArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"设备添加" TextColor:[UIColor whiteColor] Font:nil];
    [self setNavigationLeftItemWithNormalImg:[UIImage imageNamed:@"arrows_left"] highlightedImg:[UIImage imageNamed:@"arrows_left"]];
    [self setNavigationRightItemWithString:@"提交"];
    self.afreshAddressBtn.layer.masksToBounds = YES;
    self.afreshAddressBtn.layer.cornerRadius = 5;
    self.afreshAddressBtn.layer.borderColor = [ColorRequest BackGroundColor].CGColor;
    self.afreshAddressBtn.layer.borderWidth = 1.0f;
    self.afreshAddressBtn.hidden = YES;
    self.latitude = [LocationManager sharedManager].latitude;
    self.longitude = [LocationManager sharedManager].longitude;
    self.cityName = [[LocationManager sharedManager] getMyCity];
    self.districtName = [[LocationManager sharedManager] getMyDistrict];
    
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    [self reverseGeocode];
    //    [self loadMonitorType];
    self.monitorType = @"";
    self.startTimeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.startTimeBtn.layer.borderWidth = 1.0f;
    self.startTimeBtn.layer.cornerRadius = 4.0f;
    self.startTimeBtn.layer.masksToBounds = YES;
    self.endTimeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.endTimeBtn.layer.borderWidth = 1.0f;
    self.endTimeBtn.layer.cornerRadius = 4.0f;
    self.endTimeBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];
    
    self.chooseBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight)];
    self.chooseBackgroundView.backgroundColor = [UIColor blackColor];
    self.chooseBackgroundView.alpha = 0.3f;
    
    UITapGestureRecognizer *chooseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTapClick)];
    [self.chooseBackgroundView addGestureRecognizer:chooseTap];
    [self loadLastInfo];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.geocodesearch.delegate = nil; // 不用时，置nil
    [self hideSVProgressHUD];
    [LocationManager sharedManager].reverseGeocodeLocationSuccessBlock = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)leftBtnClick:(UIButton *)sender {
    [self chooseTapClick];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)endEdit {
    [self.view endEditing:YES];
}

- (void)chooseTapClick {
    
    [self.chooseBackgroundView removeFromSuperview];
    [self.chooseMonitorAccountView removeFromSuperview];
    [self.chooseMonitorTypeView removeFromSuperview];
    self.chooseMonitorAccountView.hidden = YES;
    self.chooseMonitorTypeView.hidden = YES;
    [self.monitorTypeBtn setImage:[UIImage imageNamed:@"arrows_black_down"] forState:UIControlStateNormal];
    [self.monitorAccountBtn setImage:[UIImage imageNamed:@"arrows_black_down"] forState:UIControlStateNormal];
}

- (void)loadLastInfo {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorType"] &&
        ![[[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorType"] isEqualToString:@""] && [[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorTypeString"] &&
        ![[[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorTypeString"] isEqualToString:@""]) {
        self.monitorType = [[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorType"];
        self.monitorTypeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorTypeString"];
        self.monitorTypeLabel.text = self.monitorTypeString;
    } else {
        self.monitorTypeString = @"请选择类型";
        self.monitorTypeLabel.text = self.monitorTypeString;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorAccount"] &&
        ![[[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorAccount"] isEqualToString:@""] && [[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorAccountString"] &&
        ![[[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorAccountString"] isEqualToString:@""]) {
        self.account = [[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorAccount"];
        self.accountString = [[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorAccountString"];
        self.monitorAccountLabel.text = self.accountString;
    } else {
        self.accountString = @"请选择客户";
        self.monitorAccountLabel.text = self.accountString;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorCameraTime"] &&
        ![[[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorCameraTime"] isEqualToString:@""]) {
        self.cameraTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorCameraTime"];
        self.timeTextField.text = self.cameraTime;
    } else {
        self.cameraTime = @"30";
        self.timeTextField.text = self.cameraTime;
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorStrikeTime"] &&
        ![[[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorStrikeTime"] isEqualToString:@""]) {
        self.strikeTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorStrikeTime"];
        self.strikeTimeTextField.text = self.strikeTime;
    } else {
        self.strikeTime = @"120";
        self.strikeTimeTextField.text = self.strikeTime;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorStartTime"] &&
        ![[[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorStartTime"] isEqualToString:@""]) {
        self.startTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorStartTime"];
        [self.startTimeBtn setTitle:self.startTime forState:UIControlStateNormal];
    } else {
        self.startTime = @"06:00";
        [self.startTimeBtn setTitle:self.startTime forState:UIControlStateNormal];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorEndTime"] &&
        ![[[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorEndTime"] isEqualToString:@""]) {
        self.endTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"MonitorEndTime"];
        [self.endTimeBtn setTitle:self.endTime forState:UIControlStateNormal];
    } else {
        self.endTime = @"18:00";
        [self.endTimeBtn setTitle:self.endTime forState:UIControlStateNormal];
    }
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
    } else if ([self.monitorType isEqualToString:@"请选择类型"]){
        [self showMessageWithString:@"请选择设备类型" showTime:1.0];
    } else if ([self.monitorAccountLabel.text isEqualToString:@"请选择客户"]) {
        [self showMessageWithString:@"请输入设备所属用户账号" showTime:1.0];
    } else if ([self.monitorNameTextField.text isEqualToString:@""]) {
        [self showMessageWithString:@"请输入设备编号" showTime:1.0];
    } else if ([self.monitorTelephoneTextField.text isEqualToString:@""]) {
        [self showMessageWithString:@"请输入设备电话号码" showTime:1.0];
    } else if ([self.strikeTimeTextField.text isEqualToString:@""]){
        [self showMessageWithString:@"请输入判断设备离线的时间" showTime:1.0];
    } else{
        //提交
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.view endEditing:YES];
        [SVProgressHUD show];
        [self addMonitor];
    }
}

- (IBAction)workTimeBtnClcik:(UIButton *)sender {
    [self endEdit];
    TimePickerView *picker = [[TimePickerView alloc] init];
    NSDate *chooseDate;
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    chooseDate = [dateformatter dateFromString:sender.titleLabel.text];
    picker.datePicker.date = chooseDate;
    __block TimePickerView *weakpicker = picker;
    picker.pickerBtnClickBlock = ^{
        NSString *timeString = [dateformatter stringFromDate:weakpicker.datePicker.date];
        [sender setTitle:timeString forState:UIControlStateNormal];
        [weakpicker removeFromSuperview];
    };
    [self.view addSubview:picker];
}

- (IBAction)monitorBtnClick:(UIButton *)sender {
    [[[UIApplication sharedApplication].delegate window] addSubview:self.chooseBackgroundView];
    if (self.chooseMonitorTypeView == nil) {
        [self createMonitorTypeView];
    }
    if (self.monitorTypeArray.count == 0) {
        [self loadMonitorType];
    } else {
        [self showAndHidechooseMonitorTypeView];
    }
    [self.view endEditing:YES];
}

- (void)showAndHidechooseMonitorTypeView {
    if (self.chooseMonitorTypeView.hidden) {
        self.chooseMonitorTypeView.hidden = NO;
        [[[UIApplication sharedApplication].delegate window] addSubview:self.chooseMonitorTypeView];
        [self.monitorTypeBtn setImage:[UIImage imageNamed:@"arrows_black_up"] forState:UIControlStateNormal];
    } else {
        [self.chooseBackgroundView removeFromSuperview];
        [self.chooseMonitorTypeView removeFromSuperview];
        self.chooseMonitorTypeView.hidden = YES;
        [self.monitorTypeBtn setImage:[UIImage imageNamed:@"arrows_black_down"] forState:UIControlStateNormal];
    }
}

- (IBAction)accountBtnClick:(UIButton *)sender {
    [[[UIApplication sharedApplication].delegate window] addSubview:self.chooseBackgroundView];
    if (self.chooseMonitorAccountView == nil) {
        [self createMonitorAccountView];
    }
    if (self.monitorAccountArray.count == 0) {
        [self loadMonitorAccount];
    } else {
        [self showAndHidechooseMonitorAccountView];
    }
    [self.view endEditing:YES];
}

- (void)showAndHidechooseMonitorAccountView {
    if (self.chooseMonitorAccountView.hidden) {
        self.chooseMonitorAccountView.hidden = NO;
        [[[UIApplication sharedApplication].delegate window] addSubview:self.chooseMonitorAccountView];
        [self.monitorAccountBtn setImage:[UIImage imageNamed:@"arrows_black_up"] forState:UIControlStateNormal];
    } else {
        [self.chooseBackgroundView removeFromSuperview];
        [self.chooseMonitorAccountView removeFromSuperview];
        self.chooseMonitorAccountView.hidden = YES;
        [self.monitorAccountBtn setImage:[UIImage imageNamed:@"arrows_black_down"] forState:UIControlStateNormal];
    }
}

#pragma mark - 创建类型选择View
- (void)createMonitorTypeView {
    
    self.chooseMonitorTypeView = [[ChooseMonitorTypeView alloc] init];
    self.chooseMonitorTypeView.MonitorTypeArray = self.monitorTypeArray;
    self.chooseMonitorTypeView.viewType = @"1";
    __weak AddMonitorViewController *weakself = self;
    self.chooseMonitorTypeView.cellClickBlock = ^(NSInteger index) {
        NSDictionary *dict = weakself.monitorTypeArray[index];
        weakself.monitorTypeLabel.text = [dict objectForKey:@"name"];
        weakself.monitorTypeString = [dict objectForKey:@"name"];
        weakself.monitorType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
        [weakself showAndHidechooseMonitorTypeView];
    };
    self.chooseMonitorTypeView.hidden = YES;
    [[[UIApplication sharedApplication].delegate window] addSubview:self.chooseMonitorTypeView];
}

#pragma mark - 创建用户选择View chooseMonitorAccountView
- (void)createMonitorAccountView {
    
    self.chooseMonitorAccountView = [[ChooseMonitorTypeView alloc] init];
    self.chooseMonitorAccountView.MonitorTypeArray = self.monitorAccountArray;
    self.chooseMonitorAccountView.viewType = @"1";
    __weak AddMonitorViewController *weakself = self;
    self.chooseMonitorAccountView.cellClickBlock = ^(NSInteger index) {
        NSDictionary *dict = weakself.monitorAccountArray[index];
        weakself.monitorAccountLabel.text = [dict objectForKey:@"name"];
        weakself.accountString = [dict objectForKey:@"name"];
        weakself.account = [NSString stringWithFormat:@"%@",[dict objectForKey:@"key"]];
        [weakself showAndHidechooseMonitorAccountView];
    };
    self.chooseMonitorAccountView.hidden = YES;
    [[[UIApplication sharedApplication].delegate window] addSubview:self.chooseMonitorAccountView];
}

#pragma mark - 获取设备类型
- (void)loadMonitorType {
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,MonitorTypeAPI] params:nil success:^(id responseObj) {
        [self.monitorTypeArray removeAllObjects];
        for (NSDictionary *dict in responseObj) {
            [self.monitorTypeArray addObject:dict];
        }
        CGFloat viewHegiht;
        if (self.monitorTypeArray.count * 40 > 200) {
            viewHegiht = 200;
        } else {
            viewHegiht = self.monitorTypeArray.count * 40;
        }
        self.chooseMonitorTypeView.frame = CGRectMake(self.monitorTypeBtn.frame.origin.x + self.monitorTypeBtn.frame.size.width - 130, self.monitorTypeBtn.frame.origin.y + self.monitorTypeBtn.frame.size.height + 64, 130, viewHegiht);
        [self.chooseMonitorTypeView.chooseMonitorTypeTableView reloadData];
        [self showAndHidechooseMonitorTypeView];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取设备用户
- (void)loadMonitorAccount {
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,CustomerList] params:nil success:^(id responseObj) {
        [self.monitorAccountArray removeAllObjects];
        for (NSDictionary *dict in responseObj) {
            [self.monitorAccountArray addObject:dict];
        }
        CGFloat viewHegiht;
        if (self.monitorAccountArray.count * 40 > 200) {
            viewHegiht = 200;
        } else {
            viewHegiht = self.monitorAccountArray.count * 40;
        }
        self.chooseMonitorAccountView.frame = CGRectMake(self.monitorAccountBtn.frame.origin.x + self.monitorAccountBtn.frame.size.width - 130, self.monitorAccountBtn.frame.origin.y + self.monitorAccountBtn.frame.size.height + 64, 130, viewHegiht);
        [self.chooseMonitorAccountView.chooseMonitorTypeTableView reloadData];
        [self showAndHidechooseMonitorAccountView];
    } failure:^(NSError *error) {
        
    }];
}

- (void)addMonitor {
    
    if (![self.timeTextField.text isEqualToString:@""]) {
        self.cameraTime = self.timeTextField.text;
    }
    if (![self.strikeTimeTextField.text isEqualToString:@""]) {
        self.strikeTime = self.strikeTimeTextField.text;
    }
    self.startTime = self.startTimeBtn.titleLabel.text;
    self.endTime = self.endTimeBtn.titleLabel.text;
    
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,AddMonitorAPI] params:[XinXinMonitorAPI addMonitorAddress:self.myAddressTextField.text longitude:self.longitude latitude:self.latitude cityName:self.cityName districtName:self.districtName cameraCode:self.monitorNameTextField.text phone:self.monitorTelephoneTextField.text customerKey:self.monitorAccountLabel.text monitorType:self.monitorType time:self.cameraTime strikeTime:self.strikeTime startTime:self.startTime endTime:self.endTime] success:^(id responseObj) {
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        NSDictionary *dic = responseObj;
        if ([[dic objectForKey:@"code"] integerValue] == 1) {
            
            NSUserDefaults *monitorDefault = [NSUserDefaults standardUserDefaults];
            [monitorDefault setObject:self.monitorType forKey:@"MonitorType"];
            [monitorDefault setObject:self.monitorTypeString forKey:@"MonitorTypeString"];
            [monitorDefault setObject:self.account forKey:@"MonitorAccount"];
            [monitorDefault setObject:self.accountString forKey:@"MonitorAccountString"];
            [monitorDefault setObject:self.cameraTime forKey:@"MonitorCameraTime"];
            [monitorDefault setObject:self.strikeTime forKey:@"MonitorStrikeTime"];
            [monitorDefault setObject:self.startTime forKey:@"MonitorStartTime"];
            [monitorDefault setObject:self.endTime forKey:@"MonitorEndTime"];
            [monitorDefault synchronize];
            
            
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    [textField resignFirstResponder];
    return YES;
}

- (void)reverseGeocode {
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){[[LocationManager sharedManager].latitude doubleValue], [[LocationManager sharedManager].longitude doubleValue]};
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

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == 0) {
        //        [LocationManager sharedManager].detailAddress = result.address;
        self.myAddressTextField.text = result.address;
        [LocationManager sharedManager].detailAddress = result.address;
        self.afreshAddressBtn.hidden = NO;
        [[LocationManager sharedManager] saveMyCityWithString:result.addressDetail.city];
        [[LocationManager sharedManager] saveMyDistrictWithString:result.addressDetail.district];
    }
}

- (void)geocode {
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
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

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == 0) {
        [LocationManager sharedManager].latitude = [NSString stringWithFormat:@"%f",result.location.latitude];
        [LocationManager sharedManager].longitude = [NSString stringWithFormat:@"%f",result.location.longitude];
        //        [LocationManager sharedManager].detailAddress = result.address;
        [self addMonitor];
    }
}

- (IBAction)afreshAddressBtnClick:(id)sender {
    //    [self showSVProgressHUD];
    //    [self.view endEditing:YES];
    //    //获取用户位置
    //    [[LocationManager sharedManager] currentLocation];
    //    [LocationManager sharedManager].reverseGeocodeLocationSuccessBlock = ^{
    //        [self reverseGeocode];
    //        [self hideSVProgressHUD];
    //    };
    [self.view endEditing:YES];
    __weak AddMonitorViewController *weakself = self;
    ChooseAddressInMapViewController *vc = [[ChooseAddressInMapViewController alloc] init];
    vc.ChooseAddressString = self.myAddressTextField.text;
    vc.latitude = self.latitude;
    vc.longitude = self.longitude;
    vc.cityName = self.cityName;
    vc.districtName = self.districtName;
    vc.chooseAddressInMapBlock = ^(NSString *address,NSString *latitude,NSString *longitude,NSString *cityName,NSString *districtName) {
        weakself.myAddressTextField.text = address;
        weakself.longitude = longitude;
        weakself.latitude = latitude;
        weakself.cityName = cityName;
        weakself.districtName = districtName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}


@end
