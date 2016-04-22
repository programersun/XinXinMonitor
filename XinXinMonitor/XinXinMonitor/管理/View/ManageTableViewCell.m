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

- (void)loadCellWithModel:(id)model {
    
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
