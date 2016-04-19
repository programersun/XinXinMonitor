//
//  LocationManager.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/19.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

static LocationManager *shareManager = nil;
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return  shareManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [super allocWithZone:zone];
    });
    return shareManager;
}

- (id)copyWithZone:(NSZone *)zone {
    return shareManager;
}

- (id)init {
    if (self = [super init]) {
        self.currentAddress = @"";
        self.longitude = @"";
        self.latitude = @"";
    }
    return self;
}

- (void)currentLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.currentLocationGeocoder = [[CLGeocoder alloc] init];
    if (IOS_VERSION >= 8.0) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.currentLocationGeocoder = [[CLGeocoder alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1000.0f;//用来控制定位服务更新频率。单位是“米”
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;//这个属性用来控制定位精度，精度越高耗电量越大。
    
    [self.locationManager startUpdatingLocation];}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    [self.currentLocationGeocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0) {
             CLLocationDegrees latitude  = newLocation.coordinate.latitude;
             CLLocationDegrees longitude = newLocation.coordinate.longitude;
             NSLog(@"latitude = %f,longitude = %f",latitude,longitude);
             self.latitude = [NSString stringWithFormat:@"%f",latitude];
             self.longitude = [NSString stringWithFormat:@"%f",longitude];
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString *placeName = [NSString stringWithFormat:@"%@",[placemark.addressDictionary objectForKey:@"State"]];
             self.currentAddress = placeName;
             NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
             [userDefault setObject:self.latitude forKey:@"Latitude"];
             [userDefault setObject:self.longitude forKey:@"Longitude"];
             [userDefault setObject:self.currentAddress forKey:@"Location"];
             if ([userDefault objectForKey:@"City"] == nil || [userDefault objectForKey:@"City"]) {
                 [userDefault setObject:self.currentAddress forKey:@"City"];
             }
             [userDefault synchronize];
             
         }else if (error == nil && [placemarks count] == 0){
             NSLog(@"No results were returned.");
         }else if (error != nil){
             NSLog(@"an error occurred = %@",error);
         }
     }];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined :
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
    }
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"0" forKey:@"Latitude"];
    [userDefault setObject:@"0" forKey:@"Longitude"];
    [userDefault setObject:@"" forKey:@"Location"];
    [userDefault synchronize];
}

- (void)saveCityWithDict:(NSArray *) cityArray {
    [[NSUserDefaults standardUserDefaults] setObject:cityArray forKey:@"CityArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveCityWithString:(NSString *) city {
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"City"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveDistrictWithString:(NSString *) district {
    [[NSUserDefaults standardUserDefaults] setObject:district forKey:@"District"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)getCityArray {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"CityArray"];
}

- (NSString *)getCity {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"City"];
}

- (NSString *)getDistrict {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"District"];
}

@end
