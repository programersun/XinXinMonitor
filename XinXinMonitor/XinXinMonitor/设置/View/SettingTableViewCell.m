//
//  SettingTableViewCell.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/23.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)cellWithID:(NSInteger)index {
    switch (index) {
        case 0:
            return @"accountCell";
            break;
        case 1:
            return @"changePasswordCell";
            break;
        case 2:
            return @"aboutUsCell";
            break;
        case 3:
            return @"clearCell";
            break;
        case 4:
            return @"logoutCell";
            break;
            
        default:
            return @"0";
            break;
    }
}

- (IBAction)logoutBtnClick:(id)sender {
    if (self.logoutBtnClickBlock) {
        self.logoutBtnClickBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
