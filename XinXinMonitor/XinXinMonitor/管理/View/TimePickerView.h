//
//  TimePickerView.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/21.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePickerView : UIView
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic, copy) void(^pickerBtnClickBlock)();
@end
