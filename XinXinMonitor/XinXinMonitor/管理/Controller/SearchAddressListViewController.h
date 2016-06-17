//
//  SearchAddressListViewController.h
//  XinXinMonitor
//
//  Created by 孙瑞 on 16/6/16.
//  Copyright © 2016年 瑞孙. All rights reserved.
//

#import "SR_SINOBaseViewController.h"

/**
 *  返回用户选址的地址
 *
 *  @param address 用户选址的地址
 */
typedef void(^SearchAddressInMapBlock)(NSString *address,NSString *longitude,NSString *latitude);

@interface SearchAddressListViewController : SR_SINOBaseViewController

@property (nonatomic, strong) NSString *searchAddressString;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic,copy) SearchAddressInMapBlock searchAddressInMapBlock;

@end
