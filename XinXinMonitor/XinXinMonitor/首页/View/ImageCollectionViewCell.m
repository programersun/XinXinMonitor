//
//  ImageCollectionViewCell.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/21.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (void)loadCellWithModel:(MonitorListRows *)model {
#warning 默认图片未设置
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
    self.cellTitle.text = model.code;
}

@end
