//
//  MessageTableViewCell.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/22.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadCellWithModel:(MessageRows *)model {
    self.timeLabel.text = model.sendtimeF;
    self.problemLabel.text = model.content;
    if (model.readStatus == 0) {
        self.timeLabel.textColor = [UIColor blackColor];
        self.problemLabel.textColor = [UIColor blackColor];
    } else {
        self.timeLabel.textColor = [UIColor grayColor];
        self.problemLabel.textColor = [UIColor grayColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
