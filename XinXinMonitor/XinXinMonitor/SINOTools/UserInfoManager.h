//
//  UserInfoManager.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/19.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject

/** 用户账号 */
@property (nonatomic, retain) NSString *userID;
/** 用户身份 */
@property (nonatomic, retain) NSString *userType;
/** 用户名字 */
@property (nonatomic, retain) NSString *userName;

+ (instancetype)sharedManager;

- (void)resetInfo:(NSDictionary *)dict;
- (void)saveUserInfo:(NSDictionary *)dict;

- (void)clearUserInfo;

@end
