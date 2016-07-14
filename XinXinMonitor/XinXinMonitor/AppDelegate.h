//
//  AppDelegate.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/14.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

typedef void(^ReloadMessageListBlock)();

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) ReloadMessageListBlock reloadMessageListBlock;

@end

