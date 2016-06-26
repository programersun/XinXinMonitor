//
//  ChooseMonitorTypeView.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/17.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellClickBlock)(NSInteger index);

@interface ChooseMonitorTypeView : UIView
@property (weak, nonatomic) IBOutlet UITableView *chooseMonitorTypeTableView;
@property (nonatomic, strong) NSArray *MonitorTypeArray;
@property (nonatomic, strong) NSString *viewType;  /**< view类型  1.添加设备 2.筛选 */
@property (nonatomic, copy) CellClickBlock cellClickBlock;
@end
