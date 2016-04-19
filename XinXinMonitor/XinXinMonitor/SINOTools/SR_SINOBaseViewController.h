//
//  SR_SINOBaseViewController.h
//  BaseViewController
//
//  Created by 孙瑞 on 16/3/15.
//  Copyright © 2016年 孙瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworkingTools.h"

@interface SR_SINOBaseViewController : UIViewController

/**
 *  导航标题
 *
 *  @param title     标题内容
 *  @param textColor 标题颜色 为nil时，默认黑色
 *  @param font      标题字体 为nil时，默认系统字体字号
 */
- (void)setNavigationTitle:(NSString *)title TextColor:(UIColor *)textColor Font:(UIFont *)font;

/**
 *  导航栏背景颜色
 *
 *  @param barTintColor 导航栏背景颜色
 */
- (void)setNavigationBarTintColor:(UIColor *)barTintColor;

/**
 *  导航栏按钮颜色
 *
 *  @param tintColor 导航栏按钮颜色
 */
- (void)setNavigationTintColor:(UIColor *)tintColor;

/**
 *  设置左侧文字导航按钮 默认事件为返回上个页面，其他功能需重写leftBtnClick方法
 *  不设置将显示系统backBarButtonItem
 *  @param Text 按钮文字
 */
- (void)setNavigationLeftItemWithString:(NSString *)text;

/**
 *  设置左侧图片导航按钮 默认事件为返回上个页面，其他功能需重写leftBtnClick方法
 *  不设置将显示系统backBarButtonItem
 *  @param normalImg      按钮默认图片
 *  @param highlightedImg 按钮高亮图片
 */
- (void)setNavigationLeftItemWithNormalImg:(UIImage *)normalImg highlightedImg:(UIImage *)highlightedImg;


#pragma mark 设置右侧按钮请在viewDidAppear中设置
/**
 *  设置右侧文字导航按钮 使用时需重写rightBtnClick方法
 *  
 *  @param Text 按钮文字
 */
- (void)setNavigationRightItemWithString:(NSString *)text;

/**
 *  设置右侧图片导航按钮 使用时需重写rightBtnClick方法
 *
 *  @param normalImg      按钮默认图片
 *  @param highlightedImg 按钮高亮图片
 */
- (void)setNavigationRightItemWithNormalImg:(UIImage *)normalImg highlightedImg:(UIImage *)highlightedImg;

/**
 *  设置导航图片按钮item 多个按钮时，可多次调用，设置BarButtonItems
 *
 *  @param normalImage      默认图片
 *  @param highlightedImage 点击图片
 *  @param target           代理
 *  @param action           事件
 *
 *  @return Item
 */
- (UIBarButtonItem *)navigationItemWithImage:(UIImage *)normalImage highImageName:(UIImage *)highlightedImage target:(id)target action:(SEL)action;

/**
 *  左侧按钮事件 默认为返回上个页面
 */
- (void)leftBtnClick:(UIButton *)sender;

/**
 *  右侧按钮事件
 */
- (void)rightBtnClick:(UIButton *)sender;

/**
 *  返回指定类名的ViewController
 *
 *  @param classname 类名
 */
- (void)popToViewControllerWithClassname:(NSString *)classname;

/**
 *  返回之前指定数量的ViewController
 *
 *  @param number 跳过的ViewController数量 1返回表示返回上一个界面 超出navigationController数量无反应
 */
- (void)popToViewControllerWithNumber:(NSInteger)number;
@end
