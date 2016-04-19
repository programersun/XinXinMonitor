//
//  LoginTableViewCell.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/19.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "LoginTableViewCell.h"

@implementation LoginTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellWithID:(NSInteger)index {
    switch (index) {
        case 0:
            return @"logoCell";
            break;
        case 1:
            return @"accountCell";
            break;
        case 2:
            return @"passwordCell";
            break;
        case 3:
            return @"submitCell";
            break;
            
        default:
            return @"0";
            break;
    }
}

- (IBAction)loginBtnClick:(id)sender {
    if (self.loginBtnClickBlock) {
        self.loginBtnClickBlock();
    }
}


@end
