//
//  AFNetworkingTools.h
//  BaseViewController
//
//  Created by 孙瑞 on 16/3/21.
//  Copyright © 2016年 孙瑞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^NoNetworkBlock)();

@interface AFNetworkingTools : AFHTTPSessionManager

/**
 *  网路请求没有网络时，根据需求实现自己用的功能
 */
@property(nonatomic,copy) NoNetworkBlock noNetworkBlock;

+ (instancetype)sharedManager;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)GetRequsetWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)PostRequsetWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 *  文件形式上传图片
 *
 *  @param url        请求路径
 *  @param params     请求参数
 *  @param imageArray 上传的图片数组
 *  @param success    请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure    请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)PostImageWithFormData:(NSString *)url params:(NSDictionary *)params imageArray:(NSArray *)imageArray success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 *  取消网络请求
 */
+ (void)cancelRequest;

/**
 *  网络监测 
 *  如需时时监听网路状态 在AppDelegate 的application didFinishLaunchingWithOptions 中 调用
 */
- (void)networkStateChange;

@end
