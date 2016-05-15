//
//  MonitorListRows.m
//
//  Created by 瑞 孙 on 16/5/14
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MonitorListRows.h"


NSString *const kMonitorListRowsUseStatus = @"use_status";
NSString *const kMonitorListRowsLastupdateTime = @"lastupdate_time";
NSString *const kMonitorListRowsCode = @"code";
NSString *const kMonitorListRowsCreateTime = @"create_time";
NSString *const kMonitorListRowsPkid = @"pkid";
NSString *const kMonitorListRowsStarttime = @"starttime";
NSString *const kMonitorListRowsLastupdateUsername = @"lastupdate_username";
NSString *const kMonitorListRowsEndtime = @"endtime";
NSString *const kMonitorListRowsLatitude = @"latitude";
NSString *const kMonitorListRowsLixianStatus = @"lixian_status";
NSString *const kMonitorListRowsPicsPath = @"pics_path";
NSString *const kMonitorListRowsCityName = @"city_name";
NSString *const kMonitorListRowsName = @"name";
NSString *const kMonitorListRowsLastupdateUserkey = @"lastupdate_userkey";
NSString *const kMonitorListRowsDeleteflag = @"deleteflag";
NSString *const kMonitorListRowsYinhuanStatus = @"yinhuan_status";
NSString *const kMonitorListRowsLongitude = @"longitude";
NSString *const kMonitorListRowsAreaName = @"area_name";
NSString *const kMonitorListRowsPhone = @"phone";
NSString *const kMonitorListRowsProvinceName = @"province_name";
NSString *const kMonitorListRowsCustomerKey = @"customer_key";
NSString *const kMonitorListRowsCreateUserkey = @"create_userkey";
NSString *const kMonitorListRowsStandardPicurl = @"standard_picurl";
NSString *const kMonitorListRowsRemark = @"remark";
NSString *const kMonitorListRowsAddress = @"address";
NSString *const kMonitorListRowsCreateUsername = @"create_username";


@interface MonitorListRows ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MonitorListRows

@synthesize useStatus = _useStatus;
@synthesize lastupdateTime = _lastupdateTime;
@synthesize code = _code;
@synthesize createTime = _createTime;
@synthesize pkid = _pkid;
@synthesize starttime = _starttime;
@synthesize lastupdateUsername = _lastupdateUsername;
@synthesize endtime = _endtime;
@synthesize latitude = _latitude;
@synthesize lixianStatus = _lixianStatus;
@synthesize picsPath = _picsPath;
@synthesize cityName = _cityName;
@synthesize name = _name;
@synthesize lastupdateUserkey = _lastupdateUserkey;
@synthesize deleteflag = _deleteflag;
@synthesize yinhuanStatus = _yinhuanStatus;
@synthesize longitude = _longitude;
@synthesize areaName = _areaName;
@synthesize phone = _phone;
@synthesize provinceName = _provinceName;
@synthesize customerKey = _customerKey;
@synthesize createUserkey = _createUserkey;
@synthesize standardPicurl = _standardPicurl;
@synthesize remark = _remark;
@synthesize address = _address;
@synthesize createUsername = _createUsername;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.useStatus = [[self objectOrNilForKey:kMonitorListRowsUseStatus fromDictionary:dict] doubleValue];
            self.lastupdateTime = [[self objectOrNilForKey:kMonitorListRowsLastupdateTime fromDictionary:dict] doubleValue];
            self.code = [self objectOrNilForKey:kMonitorListRowsCode fromDictionary:dict];
            self.createTime = [[self objectOrNilForKey:kMonitorListRowsCreateTime fromDictionary:dict] doubleValue];
            self.pkid = [self objectOrNilForKey:kMonitorListRowsPkid fromDictionary:dict];
            self.starttime = [self objectOrNilForKey:kMonitorListRowsStarttime fromDictionary:dict];
            self.lastupdateUsername = [self objectOrNilForKey:kMonitorListRowsLastupdateUsername fromDictionary:dict];
            self.endtime = [self objectOrNilForKey:kMonitorListRowsEndtime fromDictionary:dict];
            self.latitude = [[self objectOrNilForKey:kMonitorListRowsLatitude fromDictionary:dict] doubleValue];
            self.lixianStatus = [[self objectOrNilForKey:kMonitorListRowsLixianStatus fromDictionary:dict] doubleValue];
            self.picsPath = [self objectOrNilForKey:kMonitorListRowsPicsPath fromDictionary:dict];
            self.cityName = [self objectOrNilForKey:kMonitorListRowsCityName fromDictionary:dict];
            self.name = [self objectOrNilForKey:kMonitorListRowsName fromDictionary:dict];
            self.lastupdateUserkey = [self objectOrNilForKey:kMonitorListRowsLastupdateUserkey fromDictionary:dict];
            self.deleteflag = [[self objectOrNilForKey:kMonitorListRowsDeleteflag fromDictionary:dict] doubleValue];
            self.yinhuanStatus = [[self objectOrNilForKey:kMonitorListRowsYinhuanStatus fromDictionary:dict] doubleValue];
            self.longitude = [[self objectOrNilForKey:kMonitorListRowsLongitude fromDictionary:dict] doubleValue];
            self.areaName = [self objectOrNilForKey:kMonitorListRowsAreaName fromDictionary:dict];
            self.phone = [self objectOrNilForKey:kMonitorListRowsPhone fromDictionary:dict];
            self.provinceName = [self objectOrNilForKey:kMonitorListRowsProvinceName fromDictionary:dict];
            self.customerKey = [self objectOrNilForKey:kMonitorListRowsCustomerKey fromDictionary:dict];
            self.createUserkey = [self objectOrNilForKey:kMonitorListRowsCreateUserkey fromDictionary:dict];
            self.standardPicurl = [self objectOrNilForKey:kMonitorListRowsStandardPicurl fromDictionary:dict];
            self.remark = [self objectOrNilForKey:kMonitorListRowsRemark fromDictionary:dict];
            self.address = [self objectOrNilForKey:kMonitorListRowsAddress fromDictionary:dict];
            self.createUsername = [self objectOrNilForKey:kMonitorListRowsCreateUsername fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.useStatus] forKey:kMonitorListRowsUseStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lastupdateTime] forKey:kMonitorListRowsLastupdateTime];
    [mutableDict setValue:self.code forKey:kMonitorListRowsCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.createTime] forKey:kMonitorListRowsCreateTime];
    [mutableDict setValue:self.pkid forKey:kMonitorListRowsPkid];
    [mutableDict setValue:self.starttime forKey:kMonitorListRowsStarttime];
    [mutableDict setValue:self.lastupdateUsername forKey:kMonitorListRowsLastupdateUsername];
    [mutableDict setValue:self.endtime forKey:kMonitorListRowsEndtime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.latitude] forKey:kMonitorListRowsLatitude];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lixianStatus] forKey:kMonitorListRowsLixianStatus];
    [mutableDict setValue:self.picsPath forKey:kMonitorListRowsPicsPath];
    [mutableDict setValue:self.cityName forKey:kMonitorListRowsCityName];
    [mutableDict setValue:self.name forKey:kMonitorListRowsName];
    [mutableDict setValue:self.lastupdateUserkey forKey:kMonitorListRowsLastupdateUserkey];
    [mutableDict setValue:[NSNumber numberWithDouble:self.deleteflag] forKey:kMonitorListRowsDeleteflag];
    [mutableDict setValue:[NSNumber numberWithDouble:self.yinhuanStatus] forKey:kMonitorListRowsYinhuanStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.longitude] forKey:kMonitorListRowsLongitude];
    [mutableDict setValue:self.areaName forKey:kMonitorListRowsAreaName];
    [mutableDict setValue:self.phone forKey:kMonitorListRowsPhone];
    [mutableDict setValue:self.provinceName forKey:kMonitorListRowsProvinceName];
    [mutableDict setValue:self.customerKey forKey:kMonitorListRowsCustomerKey];
    [mutableDict setValue:self.createUserkey forKey:kMonitorListRowsCreateUserkey];
    [mutableDict setValue:self.standardPicurl forKey:kMonitorListRowsStandardPicurl];
    [mutableDict setValue:self.remark forKey:kMonitorListRowsRemark];
    [mutableDict setValue:self.address forKey:kMonitorListRowsAddress];
    [mutableDict setValue:self.createUsername forKey:kMonitorListRowsCreateUsername];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.useStatus = [aDecoder decodeDoubleForKey:kMonitorListRowsUseStatus];
    self.lastupdateTime = [aDecoder decodeDoubleForKey:kMonitorListRowsLastupdateTime];
    self.code = [aDecoder decodeObjectForKey:kMonitorListRowsCode];
    self.createTime = [aDecoder decodeDoubleForKey:kMonitorListRowsCreateTime];
    self.pkid = [aDecoder decodeObjectForKey:kMonitorListRowsPkid];
    self.starttime = [aDecoder decodeObjectForKey:kMonitorListRowsStarttime];
    self.lastupdateUsername = [aDecoder decodeObjectForKey:kMonitorListRowsLastupdateUsername];
    self.endtime = [aDecoder decodeObjectForKey:kMonitorListRowsEndtime];
    self.latitude = [aDecoder decodeDoubleForKey:kMonitorListRowsLatitude];
    self.lixianStatus = [aDecoder decodeDoubleForKey:kMonitorListRowsLixianStatus];
    self.picsPath = [aDecoder decodeObjectForKey:kMonitorListRowsPicsPath];
    self.cityName = [aDecoder decodeObjectForKey:kMonitorListRowsCityName];
    self.name = [aDecoder decodeObjectForKey:kMonitorListRowsName];
    self.lastupdateUserkey = [aDecoder decodeObjectForKey:kMonitorListRowsLastupdateUserkey];
    self.deleteflag = [aDecoder decodeDoubleForKey:kMonitorListRowsDeleteflag];
    self.yinhuanStatus = [aDecoder decodeDoubleForKey:kMonitorListRowsYinhuanStatus];
    self.longitude = [aDecoder decodeDoubleForKey:kMonitorListRowsLongitude];
    self.areaName = [aDecoder decodeObjectForKey:kMonitorListRowsAreaName];
    self.phone = [aDecoder decodeObjectForKey:kMonitorListRowsPhone];
    self.provinceName = [aDecoder decodeObjectForKey:kMonitorListRowsProvinceName];
    self.customerKey = [aDecoder decodeObjectForKey:kMonitorListRowsCustomerKey];
    self.createUserkey = [aDecoder decodeObjectForKey:kMonitorListRowsCreateUserkey];
    self.standardPicurl = [aDecoder decodeObjectForKey:kMonitorListRowsStandardPicurl];
    self.remark = [aDecoder decodeObjectForKey:kMonitorListRowsRemark];
    self.address = [aDecoder decodeObjectForKey:kMonitorListRowsAddress];
    self.createUsername = [aDecoder decodeObjectForKey:kMonitorListRowsCreateUsername];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_useStatus forKey:kMonitorListRowsUseStatus];
    [aCoder encodeDouble:_lastupdateTime forKey:kMonitorListRowsLastupdateTime];
    [aCoder encodeObject:_code forKey:kMonitorListRowsCode];
    [aCoder encodeDouble:_createTime forKey:kMonitorListRowsCreateTime];
    [aCoder encodeObject:_pkid forKey:kMonitorListRowsPkid];
    [aCoder encodeObject:_starttime forKey:kMonitorListRowsStarttime];
    [aCoder encodeObject:_lastupdateUsername forKey:kMonitorListRowsLastupdateUsername];
    [aCoder encodeObject:_endtime forKey:kMonitorListRowsEndtime];
    [aCoder encodeDouble:_latitude forKey:kMonitorListRowsLatitude];
    [aCoder encodeDouble:_lixianStatus forKey:kMonitorListRowsLixianStatus];
    [aCoder encodeObject:_picsPath forKey:kMonitorListRowsPicsPath];
    [aCoder encodeObject:_cityName forKey:kMonitorListRowsCityName];
    [aCoder encodeObject:_name forKey:kMonitorListRowsName];
    [aCoder encodeObject:_lastupdateUserkey forKey:kMonitorListRowsLastupdateUserkey];
    [aCoder encodeDouble:_deleteflag forKey:kMonitorListRowsDeleteflag];
    [aCoder encodeDouble:_yinhuanStatus forKey:kMonitorListRowsYinhuanStatus];
    [aCoder encodeDouble:_longitude forKey:kMonitorListRowsLongitude];
    [aCoder encodeObject:_areaName forKey:kMonitorListRowsAreaName];
    [aCoder encodeObject:_phone forKey:kMonitorListRowsPhone];
    [aCoder encodeObject:_provinceName forKey:kMonitorListRowsProvinceName];
    [aCoder encodeObject:_customerKey forKey:kMonitorListRowsCustomerKey];
    [aCoder encodeObject:_createUserkey forKey:kMonitorListRowsCreateUserkey];
    [aCoder encodeObject:_standardPicurl forKey:kMonitorListRowsStandardPicurl];
    [aCoder encodeObject:_remark forKey:kMonitorListRowsRemark];
    [aCoder encodeObject:_address forKey:kMonitorListRowsAddress];
    [aCoder encodeObject:_createUsername forKey:kMonitorListRowsCreateUsername];
}

- (id)copyWithZone:(NSZone *)zone
{
    MonitorListRows *copy = [[MonitorListRows alloc] init];
    
    if (copy) {

        copy.useStatus = self.useStatus;
        copy.lastupdateTime = self.lastupdateTime;
        copy.code = [self.code copyWithZone:zone];
        copy.createTime = self.createTime;
        copy.pkid = [self.pkid copyWithZone:zone];
        copy.starttime = [self.starttime copyWithZone:zone];
        copy.lastupdateUsername = [self.lastupdateUsername copyWithZone:zone];
        copy.endtime = [self.endtime copyWithZone:zone];
        copy.latitude = self.latitude;
        copy.lixianStatus = self.lixianStatus;
        copy.picsPath = [self.picsPath copyWithZone:zone];
        copy.cityName = [self.cityName copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.lastupdateUserkey = [self.lastupdateUserkey copyWithZone:zone];
        copy.deleteflag = self.deleteflag;
        copy.yinhuanStatus = self.yinhuanStatus;
        copy.longitude = self.longitude;
        copy.areaName = [self.areaName copyWithZone:zone];
        copy.phone = [self.phone copyWithZone:zone];
        copy.provinceName = [self.provinceName copyWithZone:zone];
        copy.customerKey = [self.customerKey copyWithZone:zone];
        copy.createUserkey = [self.createUserkey copyWithZone:zone];
        copy.standardPicurl = [self.standardPicurl copyWithZone:zone];
        copy.remark = [self.remark copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.createUsername = [self.createUsername copyWithZone:zone];
    }
    
    return copy;
}


@end
