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
    [dic setValue:userKey forKey:@"userKey"];
    [dic setValue:password forKey:@"password"];
    return dic;
}

+ (NSMutableDictionary *)changePasswordWithOldPasseord:(NSString *)oldPasseord newPasseord:(NSString *)newPasseord {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[UserInfoManager sharedManager].userID forKey:@"user_key"];
    [dic setValue:oldPasseord forKey:@"old_password"];
    [dic setValue:newPasseord forKey:@"new_password"];
    return dic;
}

+ (NSMutableDictionary *)monitorListWithDic:(NSMutableDictionary *)dic {
    [dic setValue:[UserInfoManager sharedManager].userID forKey:@"user_key"];
    return dic;
}

+ (NSMutableDictionary *)addMonitorAddress:(NSString *)address cameraCode:(NSString *)cameraCode phone:(NSString *)phone customerKey:(NSString *)customerKey monitorType:(NSString *)monitorType time:(NSString *)time{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[UserInfoManager sharedManager].userID forKey:@"createUserKey"];
    [dic setValue:[LocationManager sharedManager].longitude forKey:@"longitude"];
    [dic setValue:[LocationManager sharedManager].latitude forKey:@"latitude"];
    [dic setValue:[UserInfoManager sharedManager].userName forKey:@"createUserName"];
    [dic setValue:[[LocationManager sharedManager] getMyCity] forKey:@"cityName"];
    [dic setValue:[[LocationManager sharedManager] getMyDistrict] forKey:@"areaName"];
    [dic setValue:address forKey:@"address"];
    [dic setValue:cameraCode forKey:@"code"];
    [dic setValue:phone forKey:@"phone"];
    [dic setValue:customerKey forKey:@"customerKey"];
    [dic setValue:monitorType forKey:@"type"];
    [dic setValue:time forKey:@"interval"];
    return dic;
}

+ (NSMutableDictionary *)MonitorTypes {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[UserInfoManager sharedManager].departmentId forKey:@"dept_key"];
    return dic;
}

+ (NSMutableDictionary *)deleteMonitorWithMonitorID:(NSString *)monitorID {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:monitorID forKey:@"pkid"];
    return dic;
}

+ (NSMutableDictionary *)setMonitorWithMonitorID:(NSString *)monitorID status:(NSString *)status {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:monitorID forKey:@"pkid"];
    [dic setValue:status forKey:@"status"];
    return dic;
}

+ (NSMutableDictionary *)ImageList:(NSString *)monitorCode page:(NSInteger)page startTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:monitorCode forKey:@"camera_code"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [dic setValue:startTime forKey:@"start_time"];
    [dic setValue:endTime forKey:@"end_time"];
    return dic;
}

+ (NSMutableDictionary *)deleteImage:(NSString *)imagepkid {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:imagepkid forKey:@"pkid"];
    return dic;
}

+ (NSMutableDictionary *)CancelProblemImage:(NSString *)imagepkid {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:imagepkid forKey:@"pkid"];
    [dic setValue:@"1" forKey:@"status"];
    return dic;
}

+ (NSMutableDictionary *)MessageListWithPage:(NSInteger )page {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[UserInfoManager sharedManager].userID forKey:@"user_key"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    return dic;
}

+ (NSMutableDictionary *)deleteMessageWithPkid:(NSString *)messagePkid {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:messagePkid forKey:@"user_key"];
    return dic;
}

+ (NSMutableDictionary *)ReadMessageWithPkid:(NSString *)messagePkid {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:messagePkid forKey:@"user_key"];
    return dic;
}

@end
