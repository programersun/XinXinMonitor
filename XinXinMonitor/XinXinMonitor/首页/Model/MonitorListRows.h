//
//  MonitorListRows.h
//
//  Created by 瑞 孙 on 16/5/15
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MonitorListRows : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double useStatus;
@property (nonatomic, assign) double lastupdateTime;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) double createTime;
@property (nonatomic, strong) NSString *pkid;
@property (nonatomic, strong) NSString *picturePkid;
@property (nonatomic, strong) NSString *starttime;
@property (nonatomic, strong) NSString *lastupdateUsername;
@property (nonatomic, strong) NSString *endtime;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double lixianStatus;
@property (nonatomic, strong) NSString *picsPath;
@property (nonatomic, strong) NSString *lixianTime;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastupdateUserkey;
@property (nonatomic, assign) double deleteflag;
@property (nonatomic, assign) double yinhuanStatus;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *lxMessageStatus;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *customerKey;
@property (nonatomic, strong) NSString *createUserkey;
@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *standardPicurl;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *createUsername;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
