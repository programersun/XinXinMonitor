//
//  CityChangeView.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/18.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityChangeViewDelegate <NSObject>

/**
 *  选取区域
 *
 *  @param button 对应的Btn
 */
- (void)chooseDistrict:(UIButton *)button;
/**
 *  点击背景隐藏
 */
- (void)backgroundViewClick;
/**
 *  切换城市
 */
- (void)changeCityClick;

@end

@interface CityChangeView : UIView
@property (weak, nonatomic) id<CityChangeViewDelegate>delegate;
@property (nonatomic, strong) UIView *districtView;
@property (nonatomic, strong) UIView *cityView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *citylabel;
+ (id)instance;
- (void)reloadView;
@end
