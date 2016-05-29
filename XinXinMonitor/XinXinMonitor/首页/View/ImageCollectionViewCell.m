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
    NSInteger width = self.cellImageView.frame.size.width;
    NSInteger height = self.cellImageView.frame.size.height;
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile/camera/picture/icon?pkid=%@&width=%ld&height=%ld",XinXinMonitorURL,model.picturePkid,(long)width,(long)height]] placeholderImage:nil];
    self.cellTitle.text = model.code;
}

@end
