//
//  HomeTopView.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/15.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "HomeTopView.h"
static HomeTopView *instance;
@implementation HomeTopView

+ (id)instance {
    @synchronized (self) {
        if (instance == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTopView" owner:self options:nil];
            instance = [nib objectAtIndex:0];
            instance.frame = CGRectMake(0, 10, kkViewWidth - 10, 44);
            instance.searchView.layer.masksToBounds = YES;
            instance.searchView.layer.cornerRadius = 15;
            instance.backgroundColor = [ColorRequest MainBlueColor];
        }
    }
    return instance;
}

- (void)setAddressBtnTextWithString:(NSString *)addressText {
    [self.addressBtn setTitle:addressText forState:UIControlStateNormal];
    CGFloat width = [PublicUtil widthOfString:addressText withFont:15];
    self.addressBtnWidth.constant = width;
}

- (IBAction)addressBtnClick:(id)sender {
    [self.delegate addressBtnClick];
}

- (IBAction)mapBtnClick:(id)sender {
    [self.delegate mapBtnClick:sender];
}
- (IBAction)searchBtnClick:(id)sender {
    [self.searchText resignFirstResponder];
    [self.delegate searchBtnClick];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
