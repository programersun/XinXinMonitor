//
//  UIImage+SRScale.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/24.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SRScale)

// 得到图像显示完整后的frame
- (CGRect)mss_getBigImageRectSizeWithScreenWidth:(CGFloat)screenWidth screenHeight:(CGFloat)screenHeight;

@end
