//
//  ProblemImageViewController.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/5/21.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "SR_SINOBaseViewController.h"

@interface ProblemImageViewController : SR_SINOBaseViewController
@property (nonatomic, strong) NSString *pkid;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *monitorCode;
@property (nonatomic, strong) NSString *timeString;         /**< 时间*/
@property (nonatomic, assign) NSInteger enterType;  //1.问题图片. 2拍摄成功
@end
