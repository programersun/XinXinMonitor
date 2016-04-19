//
//  LoginTableViewCell.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/19.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTableViewCell : UITableViewCell

+ (NSString *)cellWithID:(NSInteger)index;

@property (weak, nonatomic) IBOutlet UIImageView *logoCellImage;

@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, copy) void(^loginBtnClickBlock)();

@end
