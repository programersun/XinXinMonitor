//
//  ChooseMonitorTypeView.m
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/17.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "ChooseMonitorTypeView.h"

@interface ChooseMonitorTypeView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChooseMonitorTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChooseMonitorTypeView" owner:self options:nil];
        self = [nib objectAtIndex:0];
        self.frame = frame;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.masksToBounds = YES;
        self.chooseMonitorTypeTableView.delegate = self;
        self.chooseMonitorTypeTableView.dataSource = self;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.MonitorTypeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.MonitorTypeArray[indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"name"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellClickBlock) {
        self.cellClickBlock(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00000001;
}

@end
