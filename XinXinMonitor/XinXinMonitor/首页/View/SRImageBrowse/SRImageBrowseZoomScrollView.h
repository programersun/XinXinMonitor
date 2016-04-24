//
//  SRImageBrowseZoomScrollView.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/24.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SRImageBrowseZoomScrollViewTapBlock)(void);

@interface SRImageBrowseZoomScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,strong)UIImageView *zoomImageView;

- (void)tapClick:(SRImageBrowseZoomScrollViewTapBlock)tapBlock;

@end
