//
//  ShouYeViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/14.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ShouYeViewController.h"
#import "HomeTopView.h"
#import "CityChangeView.h"
#import "ImageDetailViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface ShouYeViewController () <HomeTopViewDelegate,CityChangeViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,UITextFieldDelegate> {
    BMKLocationService* _locService;
}

@property (nonatomic, strong) HomeTopView *topView;
@property (nonatomic, strong) CityChangeView *cityChangeView;
@property (nonatomic, strong) UIView *tranbackView;
@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) BMKMapView *mapView;

@end

@implementation ShouYeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTopView];
    NSString *city;
    if ([[LocationManager sharedManager] getCity] != nil && [[LocationManager sharedManager] getCity]) {
        city = [[LocationManager sharedManager] getCity];
        
        //获取城市
        NSArray *array = @[@"全城",@"朝阳区",@"东城区",@"海淀区",@"西城区",@"丰台区",@"平谷区",@"延庆县",@"密云县",@"石景山区",@"山头沟",@"顺义区",@"怀柔区",@"房山区",@"昌平区"];
        NSDictionary *cityDict = @{@"City":city,@"DistrictArray":array};
        [self saveCityWithDict:cityDict];
        
        
    }else {
        city = @"济南市";
    }
    
    [self.topView setAddressBtnTextWithString:city];
    
    self.tranbackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - 49 -64)];
    self.firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - 49 -64)];
    self.firstView.backgroundColor = [UIColor redColor];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - 49 -64)];
    _mapView.delegate = self;
    
    _mapView.backgroundColor = [UIColor greenColor];
    [self.tranbackView addSubview:_mapView];
    [self.tranbackView addSubview:self.firstView];
    [self.view addSubview:self.tranbackView];
    
    _locService = [[BMKLocationService alloc]init];
    
    self.topView.searchText.delegate = self;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

/**
 *  存储城市区域信息
 *
 *  @param cityDict 城市区域信息
 */
- (void)saveCityWithDict:(NSDictionary *)cityDict {

    NSMutableArray *cityArray;
    if ([[LocationManager sharedManager] getCityArray] && [[LocationManager sharedManager] getCityArray] != nil) {
        cityArray = [[LocationManager sharedManager] getCityArray];
        BOOL exist = NO;
        for (NSDictionary *dict in cityArray) {
            if ([dict[@"City"] isEqualToString:[NSString stringWithFormat:@"%@",cityDict[@"City"]]]) {
                exist = YES;
            }
        }
        if (!exist) {
            [cityArray addObject:cityDict];
        }
    } else {
        cityArray = [[NSMutableArray alloc] initWithObjects:cityDict, nil];
    }
    [[LocationManager sharedManager] saveCityWithDict:cityArray];
    [[LocationManager sharedManager] saveDistrictWithString:@"全城"];
}

- (void)toImageDetailView {
    
}

/**
 *  设置顶部自定义导航
 */
- (void)addTopView {

    self.topView = [HomeTopView instance];
    self.topView.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.topView];
}

#pragma mark - HomeTopViewDelegate

- (void)addressBtnClick {
    
    [self.topView.searchText resignFirstResponder];
    self.cityChangeView = [CityChangeView instance];
    self.cityChangeView.delegate = self;
    //添加到window上  最顶层覆盖tabbar
    [[[UIApplication sharedApplication].delegate window] addSubview:self.cityChangeView];
    if (self.cityChangeView.hidden) {
        self.cityChangeView.hidden = NO;
        self.topView.addressArrowsBtn.imageView.image = [UIImage imageNamed:@"arrows_up"];
    } else {
        self.cityChangeView.hidden = YES;
        self.topView.addressArrowsBtn.imageView.image = [UIImage imageNamed:@"arrows_down"];
    }
}

- (void)mapBtnClick:(UIButton *)button {

    [self.topView.searchText resignFirstResponder];
    if (!self.cityChangeView.hidden) {
        self.cityChangeView.hidden = YES;
        self.topView.addressArrowsBtn.imageView.image = [UIImage imageNamed:@"arrows_down"];
    }
    if (!button.selected) {
        button.selected = YES;
        [UIView transitionFromView:self.firstView toView:_mapView duration:1.0f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            [self startLocation];
        }];

    }else {
        button.selected = NO;
        [UIView transitionFromView:_mapView toView:self.firstView duration:1.0f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            [self stopLocation];
        }];

    }
}

- (void)searchBtnClick {
    
}

#pragma mark - CityChangeViewDelegate

- (void)backgroundViewClick {
    self.cityChangeView.hidden = YES;
    self.topView.addressArrowsBtn.imageView.image = [UIImage imageNamed:@"arrows_down"];
}

- (void)chooseDistrict:(UIButton *)button {
    NSLog(@"%ld",(long)button.tag);
    NSInteger index = button.tag - 1000;
    if (0 == index) {
        
        NSString *city = [[LocationManager sharedManager] getCity];
        [self.topView setAddressBtnTextWithString:city];
        [[LocationManager sharedManager] saveDistrictWithString:@"全城"];
    } else {
        [self.topView setAddressBtnTextWithString:[NSString stringWithFormat:@"%@",button.titleLabel.text]];
        [[LocationManager sharedManager] saveDistrictWithString:[NSString stringWithFormat:@"%@",button.titleLabel.text]];
    }
    
    [self.cityChangeView reloadView];
    self.cityChangeView.hidden = YES;
    self.topView.addressArrowsBtn.imageView.image = [UIImage imageNamed:@"arrows_down"];
}

- (void)changeCityClick {
    
}


-(void)startLocation
{
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

-(void)stopLocation
{
    NSLog(@"停止定位态");
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
}

#pragma mark - BMKLocationServiceDelegate
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.05, 0.04);;
    
    BMKCoordinateRegion region = BMKCoordinateRegionMake(center, span);
    
    [_mapView setRegion:region animated:YES];
    [_mapView updateLocationData:userLocation];
    
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

#pragma mark - UITextFiledDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.cityChangeView.hidden = YES;
    self.topView.addressArrowsBtn.imageView.image = [UIImage imageNamed:@"arrows_down"];
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
