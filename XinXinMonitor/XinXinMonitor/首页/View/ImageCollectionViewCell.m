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
    NSInteger width = self.cellImageView.frame.size.width;
    NSInteger height = self.cellImageView.frame.size.height;
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile/camera/picture/icon?pkid=%@&width=%ld&height=%ld",XinXinMonitorURL,model.picturePkid,(long)width,(long)height]] placeholderImage:[UIImage imageNamed:@"ImageDefault"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    }];
    if (model.lixianStatus == 0) {
        [self.cellTitle setTextColor:[UIColor blackColor]];
    } else {
        [self.cellTitle setTextColor:[UIColor redColor]];
    }
    self.cellTitle.text = model.code;
    self.timeLabel.text = model.pictureTime;
}

@end
