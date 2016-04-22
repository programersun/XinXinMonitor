//
//  ManageTableViewCell.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/22.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *cellRightBtn;
@property (nonatomic, copy) void(^cellRightBtnClickBlock)();

- (void)loadCellWithModel:(id) model;
@end
