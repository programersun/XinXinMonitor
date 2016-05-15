//
//  XinXinMonitorAPI.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/13.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XinXinMonitorAPI : NSObject

/** APIURL*/
#define XinXinMonitorURL @"http://202.194.7.21:9097/dc_ms_mobile"
/** IMGURL*/
#define XinXinMonitorIMGURL @"http://202.194.7.21:9097"
/** 登录*/
#define LoginAPI @"/mobile/personal/checkLogin"
/** 修改密码*/
#define ChangePasswordAPI @"/mobile/personal/modifyPassword"
/** 设备列表*/
#define MonitorListAPI @"/mobile/camera/getCameraDataGrid"
/** 全部设备列表*/
#define AllMonitorListAPI @"/mobile/camera/getCameraListData"
/** 添加设备*/
#define AddMonitorAPI @"/mobile/camera/addCameraInfo"
/** 删除设备*/
#define DeleteMonitorAPI @"/mobile/camera/deleteCamera"
/** 设置隐患点*/
#define SetYinHuanStatusAPI @"/mobile/camera/modifyYinHuanStatus"
/** 消息列表*/
#define MessageListAPI @""
/** 删除消息*/
#define DeleteMessageAPI @""

#define ImageListAPI @"/mobile/camera/picture/getPicturesDataGridByCameraPkid"
/** 删除图片*/
#define DeleteImageAPI @"/mobile/camera/picture/deleteCameraPictureByPkid"
/** 取消问题图片*/
#define cancelProblemImageAPI @"/mobile/camera/picture/modifyPictureStatusByPkid"

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
 *  设备列表
 *
 *  @return 设备列表字典
 */
+ (NSMutableDictionary *)monitorListWithDic:(NSMutableDictionary *)dic;

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

/**
 *  设备删除
 *
 *  @return 设备pkid字典
 */
+ (NSMutableDictionary *)deleteMonitorWithMonitorID:(NSString *)monitorID;

/**
 *  设置/取消隐患点
 *
 *  @param monitorID 设备pkid
 *  @param status    设置 = 1 /取消 = 0
 *
 *  @return 设置/取消隐患点字典
 */
+ (NSMutableDictionary *)setMonitorWithMonitorID:(NSString *)monitorID status:(NSString *)status;

/**
 *  图片列表
 *
 *  @param monitorCode 设备编号
 *  @param page        页码
 *
 *  @return 图片列表字典
 */
+ (NSMutableDictionary *)ImageList:(NSString *)monitorCode page:(NSInteger)page startTime:(NSString *)startTime endTime:(NSString *)endTime;

/**
 *  删除图片
 *
 *  @param imageID 图片pkid
 *
 *  @return 删除图片字典
 */
+ (NSMutableDictionary *)deleteImage:(NSString *)imagepkid;

@end
