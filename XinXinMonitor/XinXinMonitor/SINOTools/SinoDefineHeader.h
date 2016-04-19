//
//  SinoDefineHeader.h
//  SINOBaseViewController
//
//  Created by 孙瑞 on 16/3/25.
//  Copyright © 2016年 孙瑞. All rights reserved.
//

#ifndef SinoDefineHeader_h
#define SinoDefineHeader_h

//判断版本号码
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define ORIGIN_X(o_x) o_x.frame.origin.x       //x
#define ORIGIN_Y(o_y) o_y.frame.origin.y       //y
#define FRAMNE_W(f_w) f_w.frame.size.width     //width
#define FRAMNE_H(f_h) f_h.frame.size.height    //height

#define CreatImage(imagePath) [UIImage imageNamed:imagePath]

//获取RGB颜色
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//屏幕宽度
#define kkViewWidth [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define kkViewHeight [UIScreen mainScreen].bounds.size.height

//屏幕缩放比例
#define KASAdapterSizeWidth kkViewWidth/320
#define KASAdapterSizeHeight kkViewHeight/568

#endif /* SinoDefineHeader_h */
