//
//  LocationManager.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/19.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocation.h>
#import <MapKit/MapKit.h>
#import "CLLocation+YCLocation.h"

typedef void(^ReverseGeocodeLocationSuccessBlock)();

@interface LocationManager : NSObject 

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *currentLocationGeocoder;
/** 当前位置 */
@property (nonatomic, strong) NSString *currentAddress;
/** 当前位置 */
@property (nonatomic, strong) NSString *detailAddress;
/** 当前位置 */
@property (nonatomic, strong) NSString *currentDistrict;
/** 经度 */
@property (nonatomic, strong) NSString *longitude;
/** 纬度 */
@property (nonatomic, strong) NSString *latitude;
/**
 *  反地理编码成功
 */
@property(nonatomic,copy) ReverseGeocodeLocationSuccessBlock reverseGeocodeLocationSuccessBlock;

+ (instancetype)sharedManager;

/**
 *  定位当前位置
 */
- (void)currentLocation;

/**
 *  存储用户选择的当前城市信息
 *
 *  @param city 当前城市名字
 */
- (void)saveCityWithString:(NSString *) city;
/**
 *  存储用户选择的当前区域信息
 *
 *  @param city 当前区域名字
 */
- (void)saveDistrictWithString:(NSString *) district;


/**
 *  存储定位的当前城市信息
 *
 *  @param city 定位城市名字
 */
- (void)saveMyCityWithString:(NSString *) city;
/**
 *  存储定位的当前区域信息
 *
 *  @param city 定位区域名字
 */
- (void)saveMyDistrictWithString:(NSString *) district;

/**
 *  获取用户选择的城市区域信息
 *
 *  @return 城市区域信息数组
 */
- (NSMutableArray *)getCityArray;
/**
 *  获取用户选择的当前城市
 *
 *  @return 用户选择的当前城市名称
 */
- (NSString *)getCity;
/**
 *  获取用户选择的当前区域信息
 *
 *  @param city 用户选择的当前区域名字
 */
- (NSString *)getDistrict;

/**
 *   获取定位当前城市信息
 *
 *  @return 定位当前城市信息
 */
- (NSString *)getMyCity;

/**
 *   获取定位当前区域信息
 *
 *  @return 定位当前区域信息
 */
- (NSString *)getMyDistrict;
/**
 *  判断用户是否开启定位，如未开启提示用户去设置中开启
 */
- (void)setLocationAuthority;

@end
