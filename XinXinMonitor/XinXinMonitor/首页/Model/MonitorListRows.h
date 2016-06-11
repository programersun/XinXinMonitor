//
//  MonitorListRows.h
//
//  Created by 瑞 孙 on 16/6/10
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MonitorListRows : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *customerKey;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, assign) double lixianStatus;
@property (nonatomic, assign) double interval;
@property (nonatomic, strong) NSString *endtime;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) double lixianTime;
@property (nonatomic, assign) double deleteflag;
@property (nonatomic, assign) double picturetime;
@property (nonatomic, assign) double createTime;
@property (nonatomic, strong) NSString *createUsername;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *lastupdateUserkey;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *createUserkey;
@property (nonatomic, strong) NSString *pictureTime;
@property (nonatomic, assign) double yinhuanStatus;
@property (nonatomic, assign) double type;
@property (nonatomic, strong) NSString *starttime;
@property (nonatomic, strong) NSString *pictureDate;
@property (nonatomic, assign) double lastupdateTime;
@property (nonatomic, strong) NSString *picturePkid;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *standardPicurl;
@property (nonatomic, strong) NSString *picsPath;
@property (nonatomic, assign) double lxMessageStatus;
@property (nonatomic, strong) NSString *lastupdateUsername;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *pkid;
@property (nonatomic, assign) double useStatus;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
