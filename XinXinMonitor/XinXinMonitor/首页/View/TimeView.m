//
//  TimeView.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/8.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "TimeView.h"

@interface TimeView ()

@property (strong, nonatomic) NSString *startTimeString;
@property (strong, nonatomic) NSString *endTimeString;
@property (assign, nonatomic) NSInteger startTime;
@property (assign, nonatomic) NSInteger endTime;

@end

@implementation TimeView

- (instancetype)init {
    if (self = [super init]) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimeView" owner:self options:nil];
        self = [nib objectAtIndex:0];
        self.frame = CGRectMake(0, 0, kkViewWidth, kkViewHeight);
        
        self.startTimeBtn.layer.masksToBounds = YES;
        self.startTimeBtn.layer.cornerRadius = 5;
        self.startTimeBtn.layer.borderColor = [UIColor blackColor].CGColor;
        self.startTimeBtn.layer.borderWidth = 1.0f;
        
        self.endTimeBtn.layer.masksToBounds = YES;
        self.endTimeBtn.layer.cornerRadius = 5;
        self.endTimeBtn.layer.borderColor = [UIColor blackColor].CGColor;
        self.endTimeBtn.layer.borderWidth = 1.0f;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
        [self.backgroundView addGestureRecognizer:tap];
        
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        self.startTimeString = [dateformatter stringFromDate:nowDate];
        self.startTimeLabel.text = self.startTimeString;
        self.endTimeString = [dateformatter stringFromDate:nowDate];
        self.endTimeLabel.text = self.endTimeString;
        
        NSDateFormatter *dateformatterString = [[NSDateFormatter alloc] init];
        [dateformatterString setDateFormat:@"YYYYMMdd"];
        self.startTime = [[dateformatterString stringFromDate:nowDate] integerValue];
        self.endTime = [[dateformatterString stringFromDate:nowDate] integerValue];
    
        self.datePicker.maximumDate = nowDate;
    }
    return self;
}

- (void)closeView {
    self.hidden = YES;
}

- (IBAction)startTimeBtnClcik:(id)sender {
    UIButton *btn = sender;
    if (!btn.selected) {
        btn.selected = YES;
        [btn setBackgroundColor:[UIColor grayColor]];
        [self.endTimeBtn setBackgroundColor:[UIColor whiteColor]];
        self.endTimeBtn.selected = NO;
        self.pickerView.hidden = NO;
    }
}

- (IBAction)endTimeBtnClcik:(id)sender {
    UIButton *btn = sender;
    if (!btn.selected) {
        btn.selected = YES;
        [btn setBackgroundColor:[UIColor grayColor]];
        [self.startTimeBtn setBackgroundColor:[UIColor whiteColor]];
        self.startTimeBtn.selected = NO;
        self.pickerView.hidden = NO;
    }
}

- (IBAction)pickerBtnClick:(id)sender {
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *timeString = [dateformatter stringFromDate:self.datePicker.date];
    
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSInteger timeInteger = [[dateformatter stringFromDate:self.datePicker.date] integerValue];
    
    if (self.startTimeBtn.selected) {
        self.startTime = timeInteger;
    }
    if (self.endTimeBtn.selected) {
        self.endTime = timeInteger;
    }
    if (self.startTime <= self.endTime) {
        if (self.startTimeBtn.selected) {
            self.startTimeString = timeString;
            self.startTimeLabel.text = timeString;
            [self.startTimeBtn setBackgroundColor:[UIColor whiteColor]];
            self.startTimeBtn.selected = NO;
            
        }
        if (self.endTimeBtn.selected) {
            self.endTimeString = timeString;
            self.endTimeLabel.text = timeString;
            [self.endTimeBtn setBackgroundColor:[UIColor whiteColor]];
            self.endTimeBtn.selected = NO;
            
        }
        self.pickerView.hidden = YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开始时间不能晚于结束时间！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)timeCheck {
    

}

@end
