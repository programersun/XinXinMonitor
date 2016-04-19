//
//  ColorRequest.h
//  ChilliCircle
//
//  Created by 孙瑞 on 15/10/22.
//  Copyright © 2015年 SinoGlobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorRequest : NSObject

//TabBar非选中状态文字颜色
+ (UIColor *)TabBarTextColor;

//TabBar背景颜色
+ (UIColor *)TabBarBackgroundColor;

//TabBar顶部阴影颜色
+(UIColor *)TabBarLineColor;

//主题红色
+ (UIColor *) MainBlueColor;

//文字颜色55
+ (UIColor *) TextColor55;

//文字颜色153
+ (UIColor *) TextColor153;

//背景颜色
+ (UIColor *) BackGroundColor;

//分割线颜色
+ (UIColor *) DividingLineColor;

//节目单正在播出节目字体颜色
+ (UIColor *) ShowListNowColor;
@end
