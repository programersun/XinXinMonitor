//
//  XinXinMonitorAPI.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/13.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "XinXinMonitorAPI.h"

@implementation XinXinMonitorAPI

+ (NSMutableDictionary *)loginWithUserKey:(NSString *)userKey password:(NSString *)password {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userKey forKey:@"userKey"];
    [dic setObject:password forKey:@"password"];
    return dic;
}

+ (NSMutableDictionary *)changePasswordWithOldPasseord:(NSString *)oldPasseord newPasseord:(NSString *)newPasseord {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[UserInfoManager sharedManager].userID forKey:@"user_key"];
    [dic setObject:oldPasseord forKey:@"old_password"];
    [dic setObject:newPasseord forKey:@"new_password"];
    return dic;
}

+ (NSMutableDictionary *)addMonitorAddress:(NSString *)address cameraCode:(NSString *)cameraCode phone:(NSString *)phone customerKey:(NSString *)customerKey {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[UserInfoManager sharedManager].userID forKey:@"createUserKey"];
    [dic setObject:[LocationManager sharedManager].longitude forKey:@"longitude"];
    [dic setObject:[LocationManager sharedManager].latitude forKey:@"latitude"];
    [dic setObject:[UserInfoManager sharedManager].userName forKey:@"createUserName"];
    [dic setObject:[[LocationManager sharedManager] getMyCity] forKey:@"cityName"];
    [dic setObject:[[LocationManager sharedManager] getDistrict] forKey:@"areaName"];
    [dic setObject:address forKey:@"address"];
    [dic setObject:cameraCode forKey:@"code"];
    [dic setObject:phone forKey:@"phone"];
    [dic setObject:customerKey forKey:@"customerKey"];
    
    return dic;
}

@end
