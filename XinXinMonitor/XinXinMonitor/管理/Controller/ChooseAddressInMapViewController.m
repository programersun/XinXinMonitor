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

@interface ChooseAddressInMapViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKDistrictSearchDelegate> {
    BMKDistrictSearch* _districtSearch;
}
@property (nonatomic, strong) BMKMapView *mapView;  /**< 地图view*/
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
@end

@implementation ChooseAddressInMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationLeftItemWithNormalImg:[UIImage imageNamed:@"arrows_left"] highlightedImg:[UIImage imageNamed:@"arrows_left"]];
    [self setNavigationRightItemWithString:@"确定"];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - 64)];
    _mapView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mapView];
    [self addAddressView];
    [self addCenterView];
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

- (void)addCenterView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kkViewWidth/2 - 10, kkViewHeight/2 - 72, 20, 40)];
    imageView.image = [UIImage imageNamed:@"mapImg"];
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
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kkViewWidth - 40, 30)];
    addressLabel.font = [UIFont systemFontOfSize:15];
    addressLabel.text = self.ChooseAddressString;
    [addAddressView addSubview:addressLabel];
    [self.view addSubview:addAddressView];
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
