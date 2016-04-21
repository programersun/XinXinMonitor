//
//  ChooseCityViewController.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/4/21.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "SR_SINOBaseViewController.h"

@interface ChooseCityViewController : SR_SINOBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *chooseCityTitleLabel;

@property(nonatomic,copy) void(^cityChangeBlock)(NSString *chooseCityString);
@end
