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
//#define XinXinMonitorURL @"http://202.194.7.21:9097/dc_ms_mobile" //测试

/** APIURL*/
#define XinXinMonitorURL @"http://60.216.117.170:90/dc_ms_mobile" //正式

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
/** 设备类型*/
#define MonitorTypeAPI @"/mobile/camera/getCameraTypeListData"
/** 我的设备类型*/
#define MyMonitorTypeAPI @"/mobile/camera/getCameraTypesByCustomer"
/** 删除设备*/
#define DeleteMonitorAPI @"/mobile/camera/deleteCamera"
/** 设置隐患点*/
#define SetYinHuanStatusAPI @"/mobile/camera/modifyYinHuanStatus"
/** 消息列表*/
#define MessageListAPI @"/mobile/message/getAppMessageDataGrid"
/** 已读消息*/
#define ReadMessageAPI @"/mobile/message/modifyReadStatus"
/** 删除消息*/
#define DeleteMessageAPI @"/mobile/message/deleteAppMessage"
/** 图片列表*/
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
 *  @param customerKey    所属类型
 *  @param customerKey    拍摄间隔
 *  @param strikeTime     离线判断时间
 *  @param startTime      开始工作时间
 *  @param endTime        结束工作时间
 *
 *  @return 设备添加字典
 */
+ (NSMutableDictionary *)addMonitorAddress:(NSString *)address cameraCode:(NSString *)cameraCode phone:(NSString *)phone customerKey:(NSString *)customerKey monitorType:(NSString *)monitorType time:(NSString *)time strikeTime:(NSString *)strikeTime startTime:(NSString *)startTime endTime:(NSString *)endTime;

/**
 *  根据部门编号获取设备类型
 *
 *  @return 根据部门编号获取设备类型字典
 */
+ (NSMutableDictionary *)MonitorTypes;

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
 *  @param startTime   开始时间
 *  @param endTime     结束时间
 *
 *  @return 图片列表字典
 */
+ (NSMutableDictionary *)ImageList:(NSString *)monitorCode page:(NSInteger)page startTime:(NSString *)startTime endTime:(NSString *)endTime;

/**
 *  删除图片
 *
 *  @param imagepkid 图片pkid
 *
 *  @return 删除图片字典
 */
+ (NSMutableDictionary *)deleteImage:(NSString *)imagepkid;

/**
 *  取消问题图片
 *
 *  @param imagepkid 图片pkid
 *
 *  @return 取消问题图片字典
 */
+ (NSMutableDictionary *)CancelProblemImage:(NSString *)imagepkid;

/**
 *  消息列表
 *
 *  @param page 页码
 *
 *  @return 消息列表字典
 */
+ (NSMutableDictionary *)MessageListWithPage:(NSInteger)page;

/**
 *  删除消息
 *
 *  @param messagePkid 消息pkid
 *
 *  @return 删除消息字典
 */
+ (NSMutableDictionary *)deleteMessageWithPkid:(NSString *)messagePkid;

/**
 *  标记已读消息
 *
 *  @param messagePkid 消息pkid
 *
 *  @return 标记已读消息字典
 */
+ (NSMutableDictionary *)ReadMessageWithPkid:(NSString *)messagePkid;

@end
