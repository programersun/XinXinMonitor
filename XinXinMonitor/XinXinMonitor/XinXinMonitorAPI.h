//
//  XinXinMonitorAPI.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/13.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XinXinMonitorAPI : NSObject

#define XinXinMonitor @"http://202.194.7.21:9097/dc_ms_mobile"

#define loginAPI @"/mobile/personal/checkLogin"

#define addMonitorAPI @"/mobile/camera/addCameraInfo"

/**
 *  登录
 *
 *  @param userKey  用户名
 *  @param password 密码
 *
 *  @return 登录参数字典
 */
+ (NSMutableDictionary *)loginWithUserKey:(NSString *)userKey password:(NSString *)password;

/**
 *  修改密码
 *
 *  @param oldPasseord 当前密码
 *  @param newPasseord 新密码
 *
 *  @return 修改密码字典
 */
+ (NSMutableDictionary *)changePasswordWithOldPasseord:(NSString *)oldPasseord newPasseord:(NSString *)newPasseord;

/**
 *  设备添加
 *
 *  @param address        中文地址
 *  @param longitude      经度
 *  @param latitude       纬度
 *  @param cameraCode     设备编号
 *  @param phone          设备电话
 *  @param createUserKey  提交人账号
 *  @param createUserName 提交人姓名
 *  @param customerKey    所属客户账号
 *
 *  @return 设备添加字典
 */
+ (NSMutableDictionary *)addMonitorAddress:(NSString *)address cameraCode:(NSString *)cameraCode phone:(NSString *)phone customerKey:(NSString *)customerKey;

@end
