//
//  HomeTopView.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/15.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeTopViewDelegate <NSObject>

/**
 *  左侧切换地址按钮点击事件
 */
- (void)addressBtnClick;
/**
 *  右侧地图按钮点击事件
 */
- (void)mapBtnClick:(UIButton *)button;
/**
 *  搜索按钮点击事件
 */
- (void)searchBtnClick;

@end

@interface HomeTopView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *addressArrowsImg;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressBtnWidth;
@property (weak, nonatomic) id<HomeTopViewDelegate>delegate;

+ (id)instance;
- (void)setAddressBtnTextWithString:(NSString *) addressText;
@end
