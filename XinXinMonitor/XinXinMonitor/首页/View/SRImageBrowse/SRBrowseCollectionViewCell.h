//
//  SRBrowseCollectionViewCell.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/24.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRBrowseLoadingView.h"
#import "SRImageBrowseZoomScrollView.h"

@class SRBrowseCollectionViewCell;

typedef void(^SRBrowseCollectionViewCellTapBlock)(SRBrowseCollectionViewCell *browseCell);
typedef void(^SRBrowseCollectionViewCellLongPressBlock)(SRBrowseCollectionViewCell *browseCell);

@interface SRBrowseCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)SRImageBrowseZoomScrollView *zoomScrollView; // 滚动视图
@property (nonatomic,strong)SRBrowseLoadingView *loadingView; // 加载视图
@property (nonatomic,strong)UIButton *problemBtn; //问题按钮
@property (nonatomic,strong)UILabel *addressLabel; //摄像头地点
@property (nonatomic,strong)UILabel *timeLabel; //图片拍摄时间
@property (nonatomic,copy) void(^ProblemBtnClickBlock)();

- (void)tapClick:(SRBrowseCollectionViewCellTapBlock)tapBlock;
- (void)longPress:(SRBrowseCollectionViewCellLongPressBlock)longPressBlock;

@end
