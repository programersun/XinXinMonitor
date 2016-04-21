//
//  ImageCollectionViewCell.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/21.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (void)loadCellWithModel:(id)model {
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:@"http://cqtv.sinosns.cn/attachments/2016/01/14524897120bf343acdae699ec.png"]];
    self.cellTitle.text = @"测试";
}

@end
