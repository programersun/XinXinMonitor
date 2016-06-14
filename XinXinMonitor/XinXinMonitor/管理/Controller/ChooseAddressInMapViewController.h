//
//  ChooseAddressInMapViewController.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/6/7.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "SR_SINOBaseViewController.h"

/**
 *  返回用户选址的地址
 *
 *  @param address 用户选址的地址
 */
typedef void(^ChooseAddressInMapBlock)(NSString *address,NSString *longitude,NSString *latitude,NSString *cityName,NSString *districtName);

@interface ChooseAddressInMapViewController : SR_SINOBaseViewController

@property (nonatomic, strong) NSString *ChooseAddressString;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *districtName;
@property (nonatomic,copy) ChooseAddressInMapBlock chooseAddressInMapBlock;

@end
