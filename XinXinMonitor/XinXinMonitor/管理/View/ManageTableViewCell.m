//
//  ManageTableViewCell.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/22.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ManageTableViewCell.h"

@implementation ManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadCellWithModel:(MonitorListRows *)model {
    
    self.nameLabel.text = model.code;
    self.addressLabel.text = model.address;
    
    if (model.lixianStatus == 1) {
        self.cellRightBtn.enabled = NO;
        [self.cellRightBtn setTitle:@"离线设备" forState:UIControlStateNormal];
    } else if (model.lixianStatus == 2) {
        self.cellRightBtn.enabled = NO;
        [self.cellRightBtn setTitle:@"问题设备" forState:UIControlStateNormal];
    } else if (model.lixianStatus == 0) {
        self.cellRightBtn.enabled = YES;
        if (model.yinhuanStatus == 0) {
            [self.cellRightBtn setTitle:@"设置隐患" forState:UIControlStateNormal];
        }
        if (model.yinhuanStatus == 1) {
            [self.cellRightBtn setTitle:@"取消隐患" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)cellRightBtnCilck:(id)sender {
    if (self.cellRightBtnClickBlock) {
        self.cellRightBtnClickBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
