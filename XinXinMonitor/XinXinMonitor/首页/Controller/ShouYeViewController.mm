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
#import "ChooseCityViewController.h"
#import "ImageDetailViewController.h"
#import "ImageCollectionViewCell.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "MonitorListBaseClass.h"
#import "MonitorListRows.h"

@interface ShouYeViewController () <HomeTopViewDelegate,CityChangeViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKDistrictSearchDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource> {
    BMKLocationService* _locService;
    BMKDistrictSearch* _districtSearch;
    CLLocationCoordinate2D _center;
    NSInteger _index;
    int _pageNum;
}

@property (nonatomic, strong) HomeTopView *topView;             /**< 首页导航*/
@property (nonatomic, strong) CityChangeView *cityChangeView;   /**< 切换城市区域*/
@property (nonatomic, strong) UIView *tranbackView;             /**< 旋转的view*/
@property (nonatomic, strong) UIView *firstView;                /**< 列表view*/
@property (nonatomic, strong) BMKMapView *mapView;              /**< 地图view*/
@property (nonatomic, strong) UICollectionView *collectionView; /**< 列表collectionview*/
@property (nonatomic, strong) NSMutableArray *monitorArray;     /**< 摄像头信息数组*/
@property (nonatomic, strong) NSMutableArray *monitorListArray;     /**< 摄像头信息数组*/
@property (nonatomic, strong) MonitorListBaseClass *monitorListBaseClass;

@end

@implementation ShouYeViewController

- (NSMutableArray *)monitorArray {
    if (!_monitorArray) {
        _monitorArray = [NSMutableArray array];
    }
    return _monitorArray;
}

- (NSMutableArray *)monitorListArray {
    if (!_monitorListArray) {
        _monitorListArray = [NSMutableArray array];
    }
    return _monitorListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAlias];
    [self addTopView];
    //显示当前位置信息
    NSString *city;
    if ([[LocationManager sharedManager] getCity] != nil && [[LocationManager sharedManager] getCity]) {
        city = [[LocationManager sharedManager] getCity];
    }else {
        city = @"济南市";
        [[LocationManager sharedManager] saveCityWithString:@"济南市"];
        [[LocationManager sharedManager] saveDistrictWithString:@"全城"];
    }
    
    if ([[LocationManager sharedManager] getMyCity] == nil && ![[LocationManager sharedManager] getMyCity]) {
        [[LocationManager sharedManager] saveMyCityWithString:@"济南市"];
        [[LocationManager sharedManager] saveMyDistrictWithString:@"全城"];
    }
    
    NSString *district = [[LocationManager sharedManager] getDistrict];
    if (![district isEqualToString:@"全城"] && district != nil) {
        [self.topView setAddressBtnTextWithString:district];
    } else {
        [self.topView setAddressBtnTextWithString:city];
    }
    
    //旋转的view 正面为列表view 反面为地图view
    self.tranbackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - 49 - 64)];
    self.firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - 49 - 64)];
    self.firstView.backgroundColor = [ColorRequest BackGroundColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置对齐方式
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //cell间距
    layout.minimumInteritemSpacing = 5.0f;
    //cell行距
    layout.minimumLineSpacing = 5.0f;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - 64 - 49) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.collectionView.backgroundColor = [ColorRequest BackGroundColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    UINib *nib = [UINib nibWithNibName:@"ImageCollectionViewCell"
                                bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    
    [self.firstView addSubview:self.collectionView];
    
    //实例化地图BMKMapView
    [self addMapView];
    
    [self.tranbackView addSubview:_mapView];
    [self.tranbackView addSubview:self.firstView];
    [self.view addSubview:self.tranbackView];
    
    self.topView.searchText.delegate = self;
    
    _pageNum = 1;
    __weak ShouYeViewController *weakself = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [weakself loadMonitorInfo];
    }];
    
    [self showSVProgressHUD];
    [self loadMonitorInfo];
    _districtSearch = [[BMKDistrictSearch alloc] init];
    
}

- (void)setAlias {
    
    if ([[UserInfoManager sharedManager].userID isEqualToString:@""]) {
        [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    }else {
        NSString *alias = [UserInfoManager sharedManager].userID;
        alias = [alias stringByReplacingOccurrencesOfString:@"." withString:@""];
        [JPUSHService setAlias:[alias stringByReplacingOccurrencesOfString:@" " withString:@""] callbackSelector:nil object:nil];
    }
}

#pragma mark - 结束加载
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark - 加载列表数据
- (void)loadMonitorInfo {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)_pageNum] forKey:@"page"];
    
    //    [dic setValue:[[LocationManager sharedManager] getCity] forKey:@"cityName"];
    //    if (![[[LocationManager sharedManager] getDistrict] isEqualToString:@"全城"]) {
    //        [dic setValue:[[LocationManager sharedManager] getDistrict] forKey:@"areaName"];
    //    }
    if (self.topView.searchText.text.length > 0) {
        [dic setValue:self.topView.searchText.text forKey:@"camera_code"];
    }
    
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,MonitorListAPI] params:[XinXinMonitorAPI monitorListWithDic:dic] success:^(id responseObj) {
        
        NSDictionary *dict = responseObj;
        
        self.monitorListBaseClass = [[MonitorListBaseClass alloc] initWithDictionary:dict];
        if (_pageNum == 1) {
            [self.monitorListArray removeAllObjects];
        }
        for (MonitorListRows *row in self.monitorListBaseClass.rows) {
            [self.monitorListArray addObject:row];
        }
        if (self.monitorListArray.count > 0) {
            [self hideSVProgressHUD];
            __weak ShouYeViewController *weakself = self;
            self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _pageNum ++;
                [weakself loadMonitorInfo];
            }];
        } else {
            [self showMessageWithString:@"暂无数据" showTime:1.0];
            self.collectionView.mj_footer = nil;
        }
        
        [self endRefresh];
        [self.collectionView reloadData];
        if (_pageNum == self.monitorListBaseClass.pagenums) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [self endRefresh];
        [self showMessageWithString:@"服务器开小差了" showTime:1.0];
    }];
}

#pragma mark - 加载地图数据
- (void)loadMapMonitorInfo {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [AFNetworkingTools GetRequsetWithUrl:[NSString stringWithFormat:@"%@%@",XinXinMonitorURL,AllMonitorListAPI] params:[XinXinMonitorAPI monitorListWithDic:dic] success:^(id responseObj) {
        
        [self.monitorArray removeAllObjects];
        for (NSDictionary *dict in responseObj) {
            MonitorListRows *model = [[MonitorListRows alloc] initWithDictionary:dict];
            [self.monitorArray addObject:model];
        }
        [self addMonitor];
        
    } failure:^(NSError *error) {
        [self showMessageWithString:@"服务器开小差了" showTime:1.0];
    }];
}

#pragma mark - 获取城市区域
- (void)loadDistrict:(NSString *) cityString{
    [self.cityChangeView reloadView];
}

#pragma mark - 实例化地图BMKMapView
- (void)addMapView {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - 49 - 64)];
    _mapView.backgroundColor = [UIColor whiteColor];
    
    //定位
    _locService = [[BMKLocationService alloc]init];
    
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    self.cityChangeView.hidden = YES;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _districtSearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    self.cityChangeView.hidden = YES;
    _mapView.delegate = nil; // // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _districtSearch.delegate = nil; // 不用时，置nil
}

/**
 *  设置顶部自定义导航
 */
- (void)addTopView {
    
    self.topView = [HomeTopView instance];
    self.topView.delegate = self;
    self.navigationItem.titleView = self.topView;
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
        //        self.topView.addressArrowsBtn.imageView.image = [UIImage imageNamed:@"arrows_up"];
        self.topView.addressArrowsImg.image = [UIImage imageNamed:@"arrows_up"];
        //获取当前城市区域
        [self loadDistrict:[[LocationManager sharedManager] getCity]];
        
    } else {
        self.cityChangeView.hidden = YES;
        self.topView.addressArrowsImg.image = [UIImage imageNamed:@"arrows_down"];
    }
}

- (void)mapBtnClick:(UIButton *)button {
    
    [self.topView.searchText resignFirstResponder];
    if (!self.cityChangeView.hidden) {
        self.cityChangeView.hidden = YES;
        self.topView.addressArrowsImg.image = [UIImage imageNamed:@"arrows_down"];
    }
    if (!button.selected) {
        button.selected = YES;
        [self.topView.mapBtn setImage:[UIImage imageNamed:@"listRight"] forState:UIControlStateNormal];
        [UIView transitionFromView:self.firstView toView:_mapView duration:1.0f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            [self startLocation];
        }];
        
    } else {
        button.selected = NO;
        [self.topView.mapBtn setImage:[UIImage imageNamed:@"mapImg"] forState:UIControlStateNormal];
        [UIView transitionFromView:_mapView toView:self.firstView duration:1.0f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            [self stopLocation];
        }];
        self.collectionView.frame = CGRectMake(0, 0, kkViewWidth, kkViewHeight - 64);
    }
}

- (void)searchBtnClick {
    
    [self.topView.searchText endEditing:YES];
    if (self.topView.searchText.text.length > 0) {
        [self showSVProgressHUD];
        _pageNum = 1;
        [self loadMonitorInfo];
    }
}

#pragma mark - CityChangeViewDelegate

- (void)backgroundViewClick {
    self.cityChangeView.hidden = YES;
    self.topView.addressArrowsImg.image = [UIImage imageNamed:@"arrows_down"];
}

- (void)chooseDistrict:(UIButton *)button {
    NSLog(@"%ld",(long)button.tag);
    NSInteger index = button.tag - 1000;
    
    NSString *chooseString = button.titleLabel.text;
    if (0 == index) {
        NSString *city = [[LocationManager sharedManager] getCity];
        [self.topView setAddressBtnTextWithString:city];
    } else {
        [self.topView setAddressBtnTextWithString:[NSString stringWithFormat:@"%@",button.titleLabel.text]];
    }
    [[LocationManager sharedManager] saveDistrictWithString:chooseString];
    
    [self.cityChangeView reloadView];
    self.cityChangeView.hidden = YES;
    self.topView.addressArrowsImg.image = [UIImage imageNamed:@"arrows_down"];
    if (self.topView.mapBtn.selected) {
        [self animationToMyChooseLocation];
    }
    [self loadMonitorInfo];
}

- (void)changeCityClick {
    ChooseCityViewController *vc = [[UIStoryboard storyboardWithName:@"ShouYeStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseCityViewController"];
    if (vc == nil) {
        vc = [[ChooseCityViewController alloc] init];
    }
    self.cityChangeView.hidden = YES;
    self.topView.addressArrowsImg.image = [UIImage imageNamed:@"arrows_down"];
    
    __weak ShouYeViewController *weakself = self;
    vc.cityChangeBlock = ^(NSString *chooseCityString){
        [weakself.topView setAddressBtnTextWithString:chooseCityString];
        [[LocationManager sharedManager] saveCityWithString:chooseCityString];
        [[LocationManager sharedManager] saveDistrictWithString:@"全城"];
        [weakself animationToMyChooseLocation];
        _pageNum = 1;
        [weakself showSVProgressHUD];
        [weakself loadMonitorInfo];
    };
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

#pragma mark - 添加大头针
-(void)addMonitor {
    
    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    int i;
    for (i = 0; i < self.monitorArray.count; i++) {
        
        MonitorListRows *model = self.monitorArray[i];
        if ([model.latitude doubleValue] != 0 && [model.longitude doubleValue] != 0 ) {
            CLLocationCoordinate2D coordinate;
            //纬度
            CLLocationDegrees latitude = [model.latitude doubleValue];
            //经度
            CLLocationDegrees longitude = [model.longitude doubleValue];
            coordinate  = (CLLocationCoordinate2D){latitude, longitude};
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
            annotation.coordinate = coordinate;
            annotation.title = model.code;
            annotation.subtitle = model.address;
            _index = i;
            [_mapView addAnnotation:annotation];
        } else {
            CLGeocoder *currentLocationGeocoder = [[CLGeocoder alloc] init];
            [currentLocationGeocoder geocodeAddressString:model.address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                if (error == nil && [placemarks count] > 0) {
                    //取出获取的地理信息数组中的第一个显示在界面上
                    CLPlacemark *firstPlacemark = [placemarks firstObject];
                    //纬度
                    CLLocationDegrees latitude = firstPlacemark.location.coordinate.latitude;
                    //经度
                    CLLocationDegrees longitude = firstPlacemark.location.coordinate.longitude;
                    CLLocationCoordinate2D coordinate;
                    CLLocation *iOSLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                    CLLocation *MarsLocation = [iOSLocation locationMarsFromEarth];
                    CLLocation *BaiduLocation = [MarsLocation locationBaiduFromMars];
                    
                    coordinate  = (CLLocationCoordinate2D){BaiduLocation.coordinate.latitude, BaiduLocation.coordinate.longitude};
                    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
                    annotation.coordinate = coordinate;
                    annotation.title = model.code;
                    annotation.subtitle = model.address;
                    _index = i;
                    [_mapView addAnnotation:annotation];
                } else {
                    NSLog(@"aaaaaaaaa");
                }
            }];
        }
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    annotationView.tag = _index;
    return annotationView;
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    MonitorListRows *model = self.monitorArray[view.tag];
    [self toImageDetailView:model];
}

#pragma mark - 进入普通定位态
-(void)startLocation
{
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    [self animationToMyChooseLocation];
    [self loadMapMonitorInfo];
}

#pragma mark - 停止定位态
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
    //    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //存储当前位置
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude] forKey:@"Latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude] forKey:@"Longitude"];
    [LocationManager sharedManager].latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    [LocationManager sharedManager].longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    [_mapView updateLocationData:userLocation];
    
}

#pragma mark - BMKMapViewDelegate

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"%f",mapView.centerCoordinate.latitude);
    NSLog(@"%f",mapView.centerCoordinate.longitude);
}

#pragma mark - 地理编码 根据城市和地址获取当前用户选择的经纬度
- (void)animationToMyChooseLocation {
    
    NSString *myChooseCity = [NSString stringWithFormat:@"%@",[[LocationManager sharedManager] getCity]];
    NSString *myChooseDistrict = [NSString stringWithFormat:@"%@",[[LocationManager sharedManager] getDistrict]];
    NSString *addressString = [NSString stringWithFormat:@"%@%@",myChooseCity,myChooseDistrict];
    if ([myChooseDistrict isEqualToString:@"全城"]) {
        addressString = myChooseCity;
    }
    //    CLGeocoder *currentLocationGeocoder = [[CLGeocoder alloc] init];
    //    [currentLocationGeocoder geocodeAddressString:addressString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
    //        if (error == nil && [placemarks count] > 0) {
    //            //取出获取的地理信息数组中的第一个显示在界面上
    //            CLPlacemark *firstPlacemark = [placemarks firstObject];
    //            //纬度
    //            CLLocationDegrees latitude = firstPlacemark.location.coordinate.latitude;
    //            //经度
    //            CLLocationDegrees longitude = firstPlacemark.location.coordinate.longitude;
    //
    //            CLLocationCoordinate2D coordinate;
    //            CLLocation *iOSLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    //            CLLocation *MarsLocation = [iOSLocation locationMarsFromEarth];
    //            CLLocation *BaiduLocation = [MarsLocation locationBaiduFromMars];
    //            
    //            coordinate  = (CLLocationCoordinate2D){BaiduLocation.coordinate.latitude, BaiduLocation.coordinate.longitude};
    //            
    //            _center.latitude = coordinate.latitude;
    //            _center.longitude = coordinate.longitude;
    //            
    //            BMKCoordinateSpan span;
    //            if ([[[LocationManager sharedManager] getDistrict] isEqualToString:@"全城"]) {
    //                span = BMKCoordinateSpanMake(0.6, 0.4);
    //            } else {
    //                span = BMKCoordinateSpanMake(0.2, 0.15);
    //            }
    //            
    //            BMKCoordinateRegion region = BMKCoordinateRegionMake(_center, span);
    //            [_mapView setRegion:region animated:YES];
    //            
    //            
    //        }else if (error == nil && [placemarks count] == 0){
    //            NSLog(@"No results were returned.");
    //        }else if (error != nil){
    //            NSLog(@"an error occurred = %@",error);
    //        }
    //    }];
    BMKDistrictSearchOption *option = [[BMKDistrictSearchOption alloc] init];
    option.city = myChooseCity;
    if (![myChooseDistrict isEqualToString:@"全城"]) {
        option.district = myChooseDistrict;
    }
    BOOL flag = [_districtSearch districtSearch:option];
    if (flag) {
        NSLog(@"district检索发送成功");
    } else {
        NSLog(@"district检索发送失败");
    }
}

/**
 *返回行政区域搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKDistrictSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDistrictResult:(BMKDistrictSearch *)searcher result:(BMKDistrictResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"onGetDistrictResult error: %d", error);
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"\nname:%@\ncode:%d\ncenter latlon:%lf,%lf", result.name, (int)result.code, result.center.latitude, result.center.longitude);
        
        BOOL flag = YES;
        for (NSString *path in result.paths) {
            BMKPolygon* polygon = [self transferPathStringToPolygon:path];
            if (polygon) {
                [_mapView addOverlay:polygon]; // 添加overlay
                if (flag) {
                    [self mapViewFitPolygon:polygon];
                    flag = NO;
                }
            }
        }
    }
}
//根据polygone设置地图范围
- (void)mapViewFitPolygon:(BMKPolygon *) polygon {
    CGFloat ltX, ltY, rbX, rbY;
    if (polygon.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polygon.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polygon.pointCount; i++) {
        BMKMapPoint pt = polygon.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

- (BMKPolygon*)transferPathStringToPolygon:(NSString*) path {
    if (path == nil || path.length < 1) {
        return nil;
    }
    NSArray *pts = [path componentsSeparatedByString:@";"];
    if (pts == nil || pts.count < 1) {
        return nil;
    }
    BMKMapPoint *points = new BMKMapPoint[pts.count];
    NSInteger index = 0;
    for (NSString *ptStr in pts) {
        if (ptStr && [ptStr rangeOfString:@","].location != NSNotFound) {
            NSRange range = [ptStr rangeOfString:@","];
            NSString *xStr = [ptStr substringWithRange:NSMakeRange(0, range.location)];
            NSString *yStr = [ptStr substringWithRange:NSMakeRange(range.location + range.length, ptStr.length - range.location - range.length)];
            if (xStr && xStr.length > 0 && [xStr respondsToSelector:@selector(doubleValue)]
                && yStr && yStr.length > 0 && [yStr respondsToSelector:@selector(doubleValue)]) {
                points[index] = BMKMapPointMake(xStr.doubleValue, yStr.doubleValue);
                index++;
            }
        }
    }
    BMKPolygon *polygon = nil;
    if (index > 0) {
        polygon = [BMKPolygon polygonWithPoints:points count:index];
    }
    delete [] points;
    return polygon;
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
    self.topView.addressArrowsImg.image = [UIImage imageNamed:@"arrows_down"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchBtnClick];
    return YES;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.monitorListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    MonitorListRows *model = self.monitorListArray[indexPath.row];
    [cell loadCellWithModel:model];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kkViewWidth - 15)/2, 160 * KASAdapterSizeWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);// top left bottom right  Cell边界范围
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MonitorListRows *model = self.monitorListArray[indexPath.row];
    [self toImageDetailView:model];
}

- (void)toImageDetailView:(MonitorListRows *)model {
    ImageDetailViewController *vc = [[UIStoryboard storyboardWithName:@"ShouYeStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageDetailViewController"];
    if (vc == nil) {
        vc = [[ImageDetailViewController alloc] init];
    }
    
    //    NSTimeInterval time = (model.lastupdateTime + 28800)/1000;
    //    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"YYYY-MM-dd"];
    //    vc.timeString = [formatter stringFromDate:date];
    vc.timeString = model.pictureDate;
    vc.problemPictureId = @"";
    vc.telephone = model.phone;
    vc.address = model.address;
    vc.monitorCode = model.code;
    vc.enterType = 1;
    [vc setHidesBottomBarWhenPushed:YES];
    [self.view endEditing:YES];
    [self.navigationController pushViewController:vc animated:YES];
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
