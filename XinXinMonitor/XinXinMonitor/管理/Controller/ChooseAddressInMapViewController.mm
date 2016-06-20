//
//  ChooseAddressInMapViewController.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/6/7.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ChooseAddressInMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "SearchAddressListViewController.h"

@interface ChooseAddressInMapViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate> {
    NSString *_searchAddressString;
}
@property (nonatomic, strong) BMKMapView *mapView;  /**< 地图view*/
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
@property (nonatomic, strong) UILabel *addressTextField;
@end

@implementation ChooseAddressInMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationLeftItemWithNormalImg:[UIImage imageNamed:@"arrows_left"] highlightedImg:[UIImage imageNamed:@"arrows_left"]];
    [self setNavigationRightItemWithString:@"确定"];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth - 90, 28)];
    titleView.backgroundColor = [UIColor clearColor];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth - 90, 28)];
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.alpha = 0.5f;
    [titleView addSubview:backgroundView];
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth - 90, 28)];
    [searchBtn setImage:[UIImage imageNamed:@"searchImg"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"地址搜索" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    titleView.layer.cornerRadius = 6.0f;
    backgroundView.layer.cornerRadius = 6.0f;
    searchBtn.layer.cornerRadius = 6.0f;
    [titleView addSubview:searchBtn];
    self.navigationItem.titleView = titleView;
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - 64)];
    _mapView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mapView];
    [self addAddressView];
    [self addCenterView];
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    [self mapViewAnimation];
    _searchAddressString = nil;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geocodesearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _geocodesearch.delegate = nil;
}

- (void)rightBtnClick:(UIButton *)sender {
    if (self.chooseAddressInMapBlock) {
        self.chooseAddressInMapBlock(self.ChooseAddressString,self.latitude,self.longitude,self.cityName,self.districtName);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mapViewAnimation {
    CLLocationCoordinate2D coordinate
    = (CLLocationCoordinate2D){[self.latitude doubleValue], [self.longitude doubleValue]};
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.01,0.01);
    BMKCoordinateRegion region = BMKCoordinateRegionMake(coordinate, span);
    [_mapView setRegion:region animated:YES];
}

- (void)addCenterView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kkViewWidth/2 - 16, kkViewHeight/2 - 64, 32, 32)];
    imageView.image = [UIImage imageNamed:@"mapMyLocation"];
    [self.view addSubview:imageView];
}

- (void)addAddressView {
    UIView *addAddressView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kkViewWidth - 20, 40)];
    addAddressView.backgroundColor = [UIColor clearColor];
    addAddressView.layer.cornerRadius = 10.0f;
    addAddressView.layer.masksToBounds = YES;
    UIView *addAddressBackgrondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth - 20, 40)];
    addAddressBackgrondView.backgroundColor = [UIColor grayColor];
    addAddressBackgrondView.alpha = 0.4f;
    [addAddressView addSubview:addAddressBackgrondView];
    self.addressTextField = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, FRAMNE_W(addAddressView) - 20, 30)];
    self.addressTextField.font = [UIFont systemFontOfSize:15];
    self.addressTextField.text = self.ChooseAddressString;
    [addAddressView addSubview:self.addressTextField];
    [self.view addSubview:addAddressView];
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"%f",mapView.region.center.latitude);
    NSLog(@"%f",mapView.region.center.longitude);
    self.latitude = [NSString stringWithFormat:@"%f",mapView.region.center.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",mapView.region.center.longitude];
    [self reverseGeocode];
}

- (void)searchBtnClick:(UIButton *)sender {
    SearchAddressListViewController *vc = [[UIStoryboard storyboardWithName:@"ManageStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchAddressListViewController"];
    __weak ChooseAddressInMapViewController *weakself = self;
    vc.searchAddressInMapBlock = ^(NSString *address,NSString *latitude,NSString *longitude) {
        weakself.longitude = longitude;
        weakself.latitude = latitude;
        [weakself mapViewAnimation];
        _searchAddressString = address;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reverseGeocode {
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){[self.latitude doubleValue], [self.longitude doubleValue]};
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

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == 0) {
        //        self.addressTextField.text = [NSString stringWithFormat:@"%@%@%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
        if (_searchAddressString) {
            self.addressTextField.text = _searchAddressString;
            _searchAddressString = nil;
        } else {
            self.addressTextField.text = result.address;
        }
        self.ChooseAddressString = result.address;
        self.cityName = result.addressDetail.city;
        self.districtName = result.addressDetail.district;
    }
}

- (void)geocode {
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.address = self.addressTextField.text;
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
        self.latitude = [NSString stringWithFormat:@"%f",result.location.latitude];
        self.longitude = [NSString stringWithFormat:@"%f",result.location.longitude];
        [self mapViewAnimation];
        [self reverseGeocode];
    }
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
    if (self.geocodesearch != nil) {
        self.geocodesearch = nil;
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
