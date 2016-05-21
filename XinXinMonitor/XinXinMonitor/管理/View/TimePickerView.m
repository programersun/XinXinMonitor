//
//  TimePickerView.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/21.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "TimePickerView.h"

@implementation TimePickerView

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimePickerView" owner:self options:nil];
        self = [nib objectAtIndex:0];
        self.frame = CGRectMake(0, 0, kkViewWidth, kkViewHeight - 64);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
        [self.backgroundView addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)closeView {
    [self removeFromSuperview];
}

- (IBAction)pickerBtnClick:(id)sender {
    if (self.pickerBtnClickBlock) {
        self.pickerBtnClickBlock();
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
