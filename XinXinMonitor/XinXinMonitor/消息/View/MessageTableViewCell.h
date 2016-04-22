//
//  MessageTableViewCell.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/22.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *problemLabel;
- (void)loadCellWithModel:(id) model;
@end
