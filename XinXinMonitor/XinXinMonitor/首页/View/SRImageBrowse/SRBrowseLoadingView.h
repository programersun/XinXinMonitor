//
//  SRBrowseLoadingView.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/24.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRBrowseLoadingView : UIView

- (void)startAnimation;
- (void)stopAnimation;
@property (nonatomic,assign)CGFloat angle;

@end
