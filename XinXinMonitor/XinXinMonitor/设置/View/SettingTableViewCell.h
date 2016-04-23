//
//  SettingTableViewCell.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/23.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *clearLabel;
@property (nonatomic, copy) void(^logoutBtnClickBlock)();

+ (NSString *)cellWithID:(NSInteger)index;

@end
