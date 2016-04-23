//
//  ImageDetailCollectionViewCell.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/23.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ImageDetailCollectionViewCell.h"

@implementation ImageDetailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)problemBtnClick:(id)sender {
    if (self.problemBtnClickBlock) {
        self.problemBtnClickBlock();
    }
}

- (void)loadCellWithModel:(id)model {
    
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:@"http://cqtv.sinosns.cn/attachments/2016/01/14524897120bf343acdae699ec.png"]];
    self.problemBtnHeight.constant = 44 * KASAdapterSizeHeight;
    self.problemBtn.layer.masksToBounds = YES;
    self.problemBtn.layer.cornerRadius = 44 * KASAdapterSizeHeight / 2;
}

@end
