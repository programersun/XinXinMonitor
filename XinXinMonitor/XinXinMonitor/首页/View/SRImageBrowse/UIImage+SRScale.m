//
//  UIImage+SRScale.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/24.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "UIImage+SRScale.h"

@implementation UIImage (SRScale)

// 得到图像显示完整后的宽度和高度
- (CGRect)mss_getBigImageRectSizeWithScreenWidth:(CGFloat)screenWidth screenHeight:(CGFloat)screenHeight
{
    CGFloat widthRatio = screenWidth / self.size.width;
    CGFloat heightRatio = screenHeight / self.size.height;
    CGFloat scale = MIN(widthRatio, heightRatio);
    CGFloat width = scale * self.size.width;
    CGFloat height = scale * self.size.height;
    return CGRectMake((screenWidth - width) / 2, (screenHeight - height) / 2, width, height);
}

@end
