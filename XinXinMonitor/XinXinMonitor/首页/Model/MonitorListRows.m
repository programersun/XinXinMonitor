//
//  MonitorListRows.m
//
//  Created by 瑞 孙 on 16/6/10
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MonitorListRows.h"


NSString *const kMonitorListRowsCustomerKey = @"customer_key";
NSString *const kMonitorListRowsLatitude = @"latitude";
NSString *const kMonitorListRowsRemark = @"remark";
NSString *const kMonitorListRowsAreaName = @"area_name";
NSString *const kMonitorListRowsLixianStatus = @"lixian_status";
NSString *const kMonitorListRowsInterval = @"interval";
NSString *const kMonitorListRowsEndtime = @"endtime";
NSString *const kMonitorListRowsAddress = @"address";
NSString *const kMonitorListRowsUrl = @"url";
NSString *const kMonitorListRowsLixianTime = @"lixian_time";
NSString *const kMonitorListRowsDeleteflag = @"deleteflag";
NSString *const kMonitorListRowsPicturetime = @"picturetime";
NSString *const kMonitorListRowsCreateTime = @"create_time";
NSString *const kMonitorListRowsCreateUsername = @"create_username";
NSString *const kMonitorListRowsName = @"name";
NSString *const kMonitorListRowsCode = @"code";
NSString *const kMonitorListRowsLastupdateUserkey = @"lastupdate_userkey";
NSString *const kMonitorListRowsLongitude = @"longitude";
NSString *const kMonitorListRowsCreateUserkey = @"create_userkey";
NSString *const kMonitorListRowsPictureTime = @"picture_time";
NSString *const kMonitorListRowsYinhuanStatus = @"yinhuan_status";
NSString *const kMonitorListRowsType = @"type_";
NSString *const kMonitorListRowsStarttime = @"starttime";
NSString *const kMonitorListRowsPictureDate = @"picture_date";
NSString *const kMonitorListRowsLastupdateTime = @"lastupdate_time";
NSString *const kMonitorListRowsPicturePkid = @"picture_pkid";
NSString *const kMonitorListRowsCityName = @"city_name";
NSString *const kMonitorListRowsProvinceName = @"province_name";
NSString *const kMonitorListRowsStandardPicurl = @"standard_picurl";
NSString *const kMonitorListRowsPicsPath = @"pics_path";
NSString *const kMonitorListRowsLxMessageStatus = @"lx_message_status";
NSString *const kMonitorListRowsLastupdateUsername = @"lastupdate_username";
NSString *const kMonitorListRowsPhone = @"phone";
NSString *const kMonitorListRowsPkid = @"pkid";
NSString *const kMonitorListRowsUseStatus = @"use_status";


@interface MonitorListRows ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MonitorListRows

@synthesize customerKey = _customerKey;
@synthesize latitude = _latitude;
@synthesize remark = _remark;
@synthesize areaName = _areaName;
@synthesize lixianStatus = _lixianStatus;
@synthesize interval = _interval;
@synthesize endtime = _endtime;
@synthesize address = _address;
@synthesize url = _url;
@synthesize lixianTime = _lixianTime;
@synthesize deleteflag = _deleteflag;
@synthesize picturetime = _picturetime;
@synthesize createTime = _createTime;
@synthesize createUsername = _createUsername;
@synthesize name = _name;
@synthesize code = _code;
@synthesize lastupdateUserkey = _lastupdateUserkey;
@synthesize longitude = _longitude;
@synthesize createUserkey = _createUserkey;
@synthesize pictureTime = _pictureTime;
@synthesize yinhuanStatus = _yinhuanStatus;
@synthesize type = _type;
@synthesize starttime = _starttime;
@synthesize pictureDate = _pictureDate;
@synthesize lastupdateTime = _lastupdateTime;
@synthesize picturePkid = _picturePkid;
@synthesize cityName = _cityName;
@synthesize provinceName = _provinceName;
@synthesize standardPicurl = _standardPicurl;
@synthesize picsPath = _picsPath;
@synthesize lxMessageStatus = _lxMessageStatus;
@synthesize lastupdateUsername = _lastupdateUsername;
@synthesize phone = _phone;
@synthesize pkid = _pkid;
@synthesize useStatus = _useStatus;


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
            self.customerKey = [self objectOrNilForKey:kMonitorListRowsCustomerKey fromDictionary:dict];
            self.latitude = [self objectOrNilForKey:kMonitorListRowsLatitude fromDictionary:dict];
            self.remark = [self objectOrNilForKey:kMonitorListRowsRemark fromDictionary:dict];
            self.areaName = [self objectOrNilForKey:kMonitorListRowsAreaName fromDictionary:dict];
            self.lixianStatus = [[self objectOrNilForKey:kMonitorListRowsLixianStatus fromDictionary:dict] doubleValue];
            self.interval = [[self objectOrNilForKey:kMonitorListRowsInterval fromDictionary:dict] doubleValue];
            self.endtime = [self objectOrNilForKey:kMonitorListRowsEndtime fromDictionary:dict];
            self.address = [self objectOrNilForKey:kMonitorListRowsAddress fromDictionary:dict];
            self.url = [self objectOrNilForKey:kMonitorListRowsUrl fromDictionary:dict];
            self.lixianTime = [[self objectOrNilForKey:kMonitorListRowsLixianTime fromDictionary:dict] doubleValue];
            self.deleteflag = [[self objectOrNilForKey:kMonitorListRowsDeleteflag fromDictionary:dict] doubleValue];
            self.picturetime = [[self objectOrNilForKey:kMonitorListRowsPicturetime fromDictionary:dict] doubleValue];
            self.createTime = [[self objectOrNilForKey:kMonitorListRowsCreateTime fromDictionary:dict] doubleValue];
            self.createUsername = [self objectOrNilForKey:kMonitorListRowsCreateUsername fromDictionary:dict];
            self.name = [self objectOrNilForKey:kMonitorListRowsName fromDictionary:dict];
            self.code = [self objectOrNilForKey:kMonitorListRowsCode fromDictionary:dict];
            self.lastupdateUserkey = [self objectOrNilForKey:kMonitorListRowsLastupdateUserkey fromDictionary:dict];
            self.longitude = [self objectOrNilForKey:kMonitorListRowsLongitude fromDictionary:dict];
            self.createUserkey = [self objectOrNilForKey:kMonitorListRowsCreateUserkey fromDictionary:dict];
            self.pictureTime = [self objectOrNilForKey:kMonitorListRowsPictureTime fromDictionary:dict];
            self.yinhuanStatus = [[self objectOrNilForKey:kMonitorListRowsYinhuanStatus fromDictionary:dict] doubleValue];
            self.type = [[self objectOrNilForKey:kMonitorListRowsType fromDictionary:dict] doubleValue];
            self.starttime = [self objectOrNilForKey:kMonitorListRowsStarttime fromDictionary:dict];
            self.pictureDate = [self objectOrNilForKey:kMonitorListRowsPictureDate fromDictionary:dict];
            self.lastupdateTime = [[self objectOrNilForKey:kMonitorListRowsLastupdateTime fromDictionary:dict] doubleValue];
            self.picturePkid = [self objectOrNilForKey:kMonitorListRowsPicturePkid fromDictionary:dict];
            self.cityName = [self objectOrNilForKey:kMonitorListRowsCityName fromDictionary:dict];
            self.provinceName = [self objectOrNilForKey:kMonitorListRowsProvinceName fromDictionary:dict];
            self.standardPicurl = [self objectOrNilForKey:kMonitorListRowsStandardPicurl fromDictionary:dict];
            self.picsPath = [self objectOrNilForKey:kMonitorListRowsPicsPath fromDictionary:dict];
            self.lxMessageStatus = [[self objectOrNilForKey:kMonitorListRowsLxMessageStatus fromDictionary:dict] doubleValue];
            self.lastupdateUsername = [self objectOrNilForKey:kMonitorListRowsLastupdateUsername fromDictionary:dict];
            self.phone = [self objectOrNilForKey:kMonitorListRowsPhone fromDictionary:dict];
            self.pkid = [self objectOrNilForKey:kMonitorListRowsPkid fromDictionary:dict];
            self.useStatus = [[self objectOrNilForKey:kMonitorListRowsUseStatus fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.customerKey forKey:kMonitorListRowsCustomerKey];
    [mutableDict setValue:self.latitude forKey:kMonitorListRowsLatitude];
    [mutableDict setValue:self.remark forKey:kMonitorListRowsRemark];
    [mutableDict setValue:self.areaName forKey:kMonitorListRowsAreaName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lixianStatus] forKey:kMonitorListRowsLixianStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.interval] forKey:kMonitorListRowsInterval];
    [mutableDict setValue:self.endtime forKey:kMonitorListRowsEndtime];
    [mutableDict setValue:self.address forKey:kMonitorListRowsAddress];
    [mutableDict setValue:self.url forKey:kMonitorListRowsUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lixianTime] forKey:kMonitorListRowsLixianTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.deleteflag] forKey:kMonitorListRowsDeleteflag];
    [mutableDict setValue:[NSNumber numberWithDouble:self.picturetime] forKey:kMonitorListRowsPicturetime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.createTime] forKey:kMonitorListRowsCreateTime];
    [mutableDict setValue:self.createUsername forKey:kMonitorListRowsCreateUsername];
    [mutableDict setValue:self.name forKey:kMonitorListRowsName];
    [mutableDict setValue:self.code forKey:kMonitorListRowsCode];
    [mutableDict setValue:self.lastupdateUserkey forKey:kMonitorListRowsLastupdateUserkey];
    [mutableDict setValue:self.longitude forKey:kMonitorListRowsLongitude];
    [mutableDict setValue:self.createUserkey forKey:kMonitorListRowsCreateUserkey];
    [mutableDict setValue:self.pictureTime forKey:kMonitorListRowsPictureTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.yinhuanStatus] forKey:kMonitorListRowsYinhuanStatus];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kMonitorListRowsType];
    [mutableDict setValue:self.starttime forKey:kMonitorListRowsStarttime];
    [mutableDict setValue:self.pictureDate forKey:kMonitorListRowsPictureDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lastupdateTime] forKey:kMonitorListRowsLastupdateTime];
    [mutableDict setValue:self.picturePkid forKey:kMonitorListRowsPicturePkid];
    [mutableDict setValue:self.cityName forKey:kMonitorListRowsCityName];
    [mutableDict setValue:self.provinceName forKey:kMonitorListRowsProvinceName];
    [mutableDict setValue:self.standardPicurl forKey:kMonitorListRowsStandardPicurl];
    [mutableDict setValue:self.picsPath forKey:kMonitorListRowsPicsPath];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lxMessageStatus] forKey:kMonitorListRowsLxMessageStatus];
    [mutableDict setValue:self.lastupdateUsername forKey:kMonitorListRowsLastupdateUsername];
    [mutableDict setValue:self.phone forKey:kMonitorListRowsPhone];
    [mutableDict setValue:self.pkid forKey:kMonitorListRowsPkid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.useStatus] forKey:kMonitorListRowsUseStatus];

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

    self.customerKey = [aDecoder decodeObjectForKey:kMonitorListRowsCustomerKey];
    self.latitude = [aDecoder decodeObjectForKey:kMonitorListRowsLatitude];
    self.remark = [aDecoder decodeObjectForKey:kMonitorListRowsRemark];
    self.areaName = [aDecoder decodeObjectForKey:kMonitorListRowsAreaName];
    self.lixianStatus = [aDecoder decodeDoubleForKey:kMonitorListRowsLixianStatus];
    self.interval = [aDecoder decodeDoubleForKey:kMonitorListRowsInterval];
    self.endtime = [aDecoder decodeObjectForKey:kMonitorListRowsEndtime];
    self.address = [aDecoder decodeObjectForKey:kMonitorListRowsAddress];
    self.url = [aDecoder decodeObjectForKey:kMonitorListRowsUrl];
    self.lixianTime = [aDecoder decodeDoubleForKey:kMonitorListRowsLixianTime];
    self.deleteflag = [aDecoder decodeDoubleForKey:kMonitorListRowsDeleteflag];
    self.picturetime = [aDecoder decodeDoubleForKey:kMonitorListRowsPicturetime];
    self.createTime = [aDecoder decodeDoubleForKey:kMonitorListRowsCreateTime];
    self.createUsername = [aDecoder decodeObjectForKey:kMonitorListRowsCreateUsername];
    self.name = [aDecoder decodeObjectForKey:kMonitorListRowsName];
    self.code = [aDecoder decodeObjectForKey:kMonitorListRowsCode];
    self.lastupdateUserkey = [aDecoder decodeObjectForKey:kMonitorListRowsLastupdateUserkey];
    self.longitude = [aDecoder decodeObjectForKey:kMonitorListRowsLongitude];
    self.createUserkey = [aDecoder decodeObjectForKey:kMonitorListRowsCreateUserkey];
    self.pictureTime = [aDecoder decodeObjectForKey:kMonitorListRowsPictureTime];
    self.yinhuanStatus = [aDecoder decodeDoubleForKey:kMonitorListRowsYinhuanStatus];
    self.type = [aDecoder decodeDoubleForKey:kMonitorListRowsType];
    self.starttime = [aDecoder decodeObjectForKey:kMonitorListRowsStarttime];
    self.pictureDate = [aDecoder decodeObjectForKey:kMonitorListRowsPictureDate];
    self.lastupdateTime = [aDecoder decodeDoubleForKey:kMonitorListRowsLastupdateTime];
    self.picturePkid = [aDecoder decodeObjectForKey:kMonitorListRowsPicturePkid];
    self.cityName = [aDecoder decodeObjectForKey:kMonitorListRowsCityName];
    self.provinceName = [aDecoder decodeObjectForKey:kMonitorListRowsProvinceName];
    self.standardPicurl = [aDecoder decodeObjectForKey:kMonitorListRowsStandardPicurl];
    self.picsPath = [aDecoder decodeObjectForKey:kMonitorListRowsPicsPath];
    self.lxMessageStatus = [aDecoder decodeDoubleForKey:kMonitorListRowsLxMessageStatus];
    self.lastupdateUsername = [aDecoder decodeObjectForKey:kMonitorListRowsLastupdateUsername];
    self.phone = [aDecoder decodeObjectForKey:kMonitorListRowsPhone];
    self.pkid = [aDecoder decodeObjectForKey:kMonitorListRowsPkid];
    self.useStatus = [aDecoder decodeDoubleForKey:kMonitorListRowsUseStatus];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_customerKey forKey:kMonitorListRowsCustomerKey];
    [aCoder encodeObject:_latitude forKey:kMonitorListRowsLatitude];
    [aCoder encodeObject:_remark forKey:kMonitorListRowsRemark];
    [aCoder encodeObject:_areaName forKey:kMonitorListRowsAreaName];
    [aCoder encodeDouble:_lixianStatus forKey:kMonitorListRowsLixianStatus];
    [aCoder encodeDouble:_interval forKey:kMonitorListRowsInterval];
    [aCoder encodeObject:_endtime forKey:kMonitorListRowsEndtime];
    [aCoder encodeObject:_address forKey:kMonitorListRowsAddress];
    [aCoder encodeObject:_url forKey:kMonitorListRowsUrl];
    [aCoder encodeDouble:_lixianTime forKey:kMonitorListRowsLixianTime];
    [aCoder encodeDouble:_deleteflag forKey:kMonitorListRowsDeleteflag];
    [aCoder encodeDouble:_picturetime forKey:kMonitorListRowsPicturetime];
    [aCoder encodeDouble:_createTime forKey:kMonitorListRowsCreateTime];
    [aCoder encodeObject:_createUsername forKey:kMonitorListRowsCreateUsername];
    [aCoder encodeObject:_name forKey:kMonitorListRowsName];
    [aCoder encodeObject:_code forKey:kMonitorListRowsCode];
    [aCoder encodeObject:_lastupdateUserkey forKey:kMonitorListRowsLastupdateUserkey];
    [aCoder encodeObject:_longitude forKey:kMonitorListRowsLongitude];
    [aCoder encodeObject:_createUserkey forKey:kMonitorListRowsCreateUserkey];
    [aCoder encodeObject:_pictureTime forKey:kMonitorListRowsPictureTime];
    [aCoder encodeDouble:_yinhuanStatus forKey:kMonitorListRowsYinhuanStatus];
    [aCoder encodeDouble:_type forKey:kMonitorListRowsType];
    [aCoder encodeObject:_starttime forKey:kMonitorListRowsStarttime];
    [aCoder encodeObject:_pictureDate forKey:kMonitorListRowsPictureDate];
    [aCoder encodeDouble:_lastupdateTime forKey:kMonitorListRowsLastupdateTime];
    [aCoder encodeObject:_picturePkid forKey:kMonitorListRowsPicturePkid];
    [aCoder encodeObject:_cityName forKey:kMonitorListRowsCityName];
    [aCoder encodeObject:_provinceName forKey:kMonitorListRowsProvinceName];
    [aCoder encodeObject:_standardPicurl forKey:kMonitorListRowsStandardPicurl];
    [aCoder encodeObject:_picsPath forKey:kMonitorListRowsPicsPath];
    [aCoder encodeDouble:_lxMessageStatus forKey:kMonitorListRowsLxMessageStatus];
    [aCoder encodeObject:_lastupdateUsername forKey:kMonitorListRowsLastupdateUsername];
    [aCoder encodeObject:_phone forKey:kMonitorListRowsPhone];
    [aCoder encodeObject:_pkid forKey:kMonitorListRowsPkid];
    [aCoder encodeDouble:_useStatus forKey:kMonitorListRowsUseStatus];
}

- (id)copyWithZone:(NSZone *)zone
{
    MonitorListRows *copy = [[MonitorListRows alloc] init];
    
    if (copy) {

        copy.customerKey = [self.customerKey copyWithZone:zone];
        copy.latitude = [self.latitude copyWithZone:zone];
        copy.remark = [self.remark copyWithZone:zone];
        copy.areaName = [self.areaName copyWithZone:zone];
        copy.lixianStatus = self.lixianStatus;
        copy.interval = self.interval;
        copy.endtime = [self.endtime copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.lixianTime = self.lixianTime;
        copy.deleteflag = self.deleteflag;
        copy.picturetime = self.picturetime;
        copy.createTime = self.createTime;
        copy.createUsername = [self.createUsername copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.code = [self.code copyWithZone:zone];
        copy.lastupdateUserkey = [self.lastupdateUserkey copyWithZone:zone];
        copy.longitude = [self.longitude copyWithZone:zone];
        copy.createUserkey = [self.createUserkey copyWithZone:zone];
        copy.pictureTime = [self.pictureTime copyWithZone:zone];
        copy.yinhuanStatus = self.yinhuanStatus;
        copy.type = self.type;
        copy.starttime = [self.starttime copyWithZone:zone];
        copy.pictureDate = [self.pictureDate copyWithZone:zone];
        copy.lastupdateTime = self.lastupdateTime;
        copy.picturePkid = [self.picturePkid copyWithZone:zone];
        copy.cityName = [self.cityName copyWithZone:zone];
        copy.provinceName = [self.provinceName copyWithZone:zone];
        copy.standardPicurl = [self.standardPicurl copyWithZone:zone];
        copy.picsPath = [self.picsPath copyWithZone:zone];
        copy.lxMessageStatus = self.lxMessageStatus;
        copy.lastupdateUsername = [self.lastupdateUsername copyWithZone:zone];
        copy.phone = [self.phone copyWithZone:zone];
        copy.pkid = [self.pkid copyWithZone:zone];
        copy.useStatus = self.useStatus;
    }
    
    return copy;
}


@end
