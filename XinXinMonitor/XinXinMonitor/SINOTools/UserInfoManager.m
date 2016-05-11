//
//  UserInfoManager.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/19.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

static UserInfoManager *shareManager = nil;
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
        self.userID = @"";
//        self.userAccount = @"";
    }
    return  self;
}

- (void)resetInfo:(NSDictionary *)dict {
    self.userID = [dict objectForKey:@"userid"];
}

- (void)saveUserInfo:(NSDictionary *)dict {
    
    [self resetInfo:dict];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
}

@end
