//
//  ImageDetailViewController.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/14.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "SR_SINOBaseViewController.h"

@interface ImageDetailViewController : SR_SINOBaseViewController
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *monitorCode;
@property (nonatomic, strong) NSString *problemPictureId;
@property (nonatomic, strong) NSString *timeString;         /**< 时间*/

@end
