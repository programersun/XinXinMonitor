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
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface ShouYeViewController () <HomeTopViewDelegate,CityChangeViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource> {
    BMKLocationService* _locService;
    CLLocationCoordinate2D _center;
}

@property (nonatomic, strong) HomeTopView *topView;             /**< 首页导航*/
@property (nonatomic, strong) CityChangeView *cityChangeView;   /**< 切换城市区域*/
@property (nonatomic, strong) UIView *tranbackView;             /**< 旋转的view*/
@property (nonatomic, strong) UIView *firstView;                /**< 列表view*/
@property (nonatomic, strong) BMKMapView *mapView;              /**< 地图view*/
@property (nonatomic, strong) UICollectionView *collectionView; /**< 列表collectionview*/

@end

@implementation ShouYeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTopView];
    
    //显示当前位置信息
    NSString *city;
    if ([[LocationManager sharedManager] getCity] != nil && [[LocationManager sharedManager] getCity]) {
        city = [[LocationManager sharedManager] getCity];
    }else {
        city = @"济南市";
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
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - 49 - 64) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
//    self.collectionView.pagingEnabled = YES;
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
}

#pragma mark - 获取城市区域
- (void)loadDistrict:(NSString *) cityString{
    
    
    //获取城市
    NSArray *array = @[@"全城",@"朝阳区",@"东城区",@"海淀区",@"西城区",@"丰台区",@"平谷区",@"延庆县",@"密云县",@"石景山区",@"门头沟",@"顺义区",@"怀柔区",@"房山区",@"昌平区",@"通州区",@"大兴区"];
    NSDictionary *cityDict = @{@"City":cityString,@"DistrictArray":array};
    [self saveCityWithDict:cityDict];
    [self.cityChangeView reloadView];
    
}

#pragma mark - 实例化地图BMKMapView
- (void)addMapView {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - 49 -64)];
    _mapView.backgroundColor = [UIColor greenColor];
    
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
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

/**
 *  存储城市区域信息
 *
 *  @param cityDict 城市区域信息
 */
- (void)saveCityWithDict:(NSDictionary *)cityDict {

    //便利存储的城市区域信心，如没有添加后重新存储
    NSMutableArray *cityArray = [[NSMutableArray alloc] init];
    if ([[LocationManager sharedManager] getCityArray] && [[LocationManager sharedManager] getCityArray] != nil) {
        BOOL exist = NO;
        for (NSDictionary *dict in [[LocationManager sharedManager] getCityArray]) {
            [cityArray addObject:dict];
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
    if ([[LocationManager sharedManager] getDistrict] == nil) {
        [[LocationManager sharedManager] saveDistrictWithString:[LocationManager sharedManager].currentDistrict];
    }
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
        
        //获取当前城市区域
        [self loadDistrict:[[LocationManager sharedManager] getCity]];
        
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
    self.topView.addressArrowsBtn.imageView.image = [UIImage imageNamed:@"arrows_down"];
    if (self.topView.mapBtn.selected) {
        [self animationToMyChooseLocation];
    }
}

- (void)changeCityClick {
    ChooseCityViewController *vc = [[UIStoryboard storyboardWithName:@"ShouYeStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseCityViewController"];
    if (vc == nil) {
        vc = [[ChooseCityViewController alloc] init];
    }
    self.cityChangeView.hidden = YES;
    self.topView.addressArrowsBtn.imageView.image = [UIImage imageNamed:@"arrows_down"];
    
    vc.cityChangeBlock = ^(NSString *chooseCityString){
        [self.topView setAddressBtnTextWithString:chooseCityString];
        [[LocationManager sharedManager] saveCityWithString:chooseCityString];
        [[LocationManager sharedManager] saveDistrictWithString:@"全城"];
    };
    [self presentViewController:vc animated:YES completion:^{
        
    }];
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
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    //存储当前位置
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude] forKey:@"Latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude] forKey:@"Longitude"];
    [LocationManager sharedManager].latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    [LocationManager sharedManager].longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    [_mapView updateLocationData:userLocation];
    
}

#pragma mark - 地理编码 根据城市和地址获取当前用户选择的经纬度
- (void)animationToMyChooseLocation {
    
    NSString *myChooseCity = [NSString stringWithFormat:@"%@",[[LocationManager sharedManager] getCity]];
    NSString *myChooseDistrict = [NSString stringWithFormat:@"%@",[[LocationManager sharedManager] getDistrict]];
    NSString *addressString = [NSString stringWithFormat:@"%@%@",myChooseCity,myChooseDistrict];
    if ([myChooseDistrict isEqualToString:@"全城"]) {
        addressString = myChooseCity;
    }
    
    [[LocationManager sharedManager].currentLocationGeocoder geocodeAddressString:addressString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error == nil && [placemarks count] > 0) {
            //取出获取的地理信息数组中的第一个显示在界面上
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            //纬度
            CLLocationDegrees latitude=firstPlacemark.location.coordinate.latitude;
            //经度
            CLLocationDegrees longitude=firstPlacemark.location.coordinate.longitude;

            _center.latitude = latitude;
            _center.longitude = longitude;
            BMKCoordinateSpan span;
            if ([[[LocationManager sharedManager] getDistrict] isEqualToString:@"全城"]) {
                span = BMKCoordinateSpanMake(0.6, 0.4);
            } else {
                span = BMKCoordinateSpanMake(0.2, 0.15);
            }
            
            BMKCoordinateRegion region = BMKCoordinateRegionMake(_center, span);
            [_mapView setRegion:region animated:YES];
            
            
        }else if (error == nil && [placemarks count] == 0){
            NSLog(@"No results were returned.");
        }else if (error != nil){
            NSLog(@"an error occurred = %@",error);
        }
    }];
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell loadCellWithModel:@""];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kkViewWidth - 30)/2, 185 * KASAdapterSizeHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);// top left bottom right  Cell边界范围
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageDetailViewController *vc = [[UIStoryboard storyboardWithName:@"ShouYeStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageDetailViewController"];
    if (vc == nil) {
        vc = [[ImageDetailViewController alloc] init];
    }
    [vc setHidesBottomBarWhenPushed:YES];
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
