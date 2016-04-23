//
//  ImageDetailCollectionViewCell.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/23.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDetailCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *problemBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *problemBtnHeight;
@property (nonatomic, copy) void(^problemBtnClickBlock)();

- (void)loadCellWithModel:(id) model;

@end
