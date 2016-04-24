//
//  XinXinMonitorHeader.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/14.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#ifndef XinXinMonitorHeader_h

#ifdef __OBJC__
#import "AFNetworkingTools.h"
#import "JPUSHService.h"
#import "MBProgressHUD.h"
#import "PublicUtil.h"
#import "SVProgressHUD.h"
#import "SinoDefineHeader.h"
#import "UIImageView+WebCache.h"
#import <Availability.h>
#import "ColorRequest.h"
#import "LocationManager.h"
#import "UserInfoManager.h"

#import "UIView+SRLayout.h"

#endif

#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()

#define XinXinMonitorHeader_h


#endif /* XinXinMonitorHeader_h */
