//
//  UserInfoManager.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/19.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject

@property (nonatomic, retain) NSString *userID;
//@property (nonatomic, retain) NSString *userAccount;

+ (instancetype)sharedManager;

- (void)resetInfo:(NSDictionary *)dict;
- (void)saveUserInfo:(NSDictionary *)dict;

- (void)clearUserInfo;

@end
