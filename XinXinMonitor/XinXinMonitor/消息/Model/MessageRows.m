//
//  MessageRows.m
//
//  Created by 瑞 孙 on 16/5/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MessageRows.h"


NSString *const kMessageRowsType = @"type_";
NSString *const kMessageRowsPhone = @"phone";
NSString *const kMessageRowsCameraPkid = @"camera_pkid";
NSString *const kMessageRowsPkid = @"pkid";
NSString *const kMessageRowsSendtime = @"sendtime";
NSString *const kMessageRowsUserkey = @"userkey";
NSString *const kMessageRowsPictureTime = @"picture_time";
NSString *const kMessageRowsDeleteFlag = @"delete_flag";
NSString *const kMessageRowsAddress = @"address";
NSString *const kMessageRowsPictureDateF = @"picture_date_f";
NSString *const kMessageRowsReadTime = @"read_time";
NSString *const kMessageRowsCameraCode = @"camera_code";
NSString *const kMessageRowsPicturePkid = @"picture_pkid";
NSString *const kMessageRowsRemark = @"remark";
NSString *const kMessageRowsPictureTimeF = @"picture_time_f";
NSString *const kMessageRowsSendtimeF = @"sendtime_f";
NSString *const kMessageRowsReadStatus = @"read_status";
NSString *const kMessageRowsContent = @"content";


@interface MessageRows ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MessageRows

@synthesize type = _type;
@synthesize phone = _phone;
@synthesize cameraPkid = _cameraPkid;
@synthesize pkid = _pkid;
@synthesize sendtime = _sendtime;
@synthesize userkey = _userkey;
@synthesize pictureTime = _pictureTime;
@synthesize deleteFlag = _deleteFlag;
@synthesize address = _address;
@synthesize pictureDateF = _pictureDateF;
@synthesize readTime = _readTime;
@synthesize cameraCode = _cameraCode;
@synthesize picturePkid = _picturePkid;
@synthesize remark = _remark;
@synthesize pictureTimeF = _pictureTimeF;
@synthesize sendtimeF = _sendtimeF;
@synthesize readStatus = _readStatus;
@synthesize content = _content;


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
            self.type = [[self objectOrNilForKey:kMessageRowsType fromDictionary:dict] doubleValue];
            self.phone = [self objectOrNilForKey:kMessageRowsPhone fromDictionary:dict];
            self.cameraPkid = [self objectOrNilForKey:kMessageRowsCameraPkid fromDictionary:dict];
            self.pkid = [self objectOrNilForKey:kMessageRowsPkid fromDictionary:dict];
            self.sendtime = [[self objectOrNilForKey:kMessageRowsSendtime fromDictionary:dict] doubleValue];
            self.userkey = [self objectOrNilForKey:kMessageRowsUserkey fromDictionary:dict];
            self.pictureTime = [[self objectOrNilForKey:kMessageRowsPictureTime fromDictionary:dict] doubleValue];
            self.deleteFlag = [[self objectOrNilForKey:kMessageRowsDeleteFlag fromDictionary:dict] doubleValue];
            self.address = [self objectOrNilForKey:kMessageRowsAddress fromDictionary:dict];
            self.pictureDateF = [self objectOrNilForKey:kMessageRowsPictureDateF fromDictionary:dict];
            self.readTime = [[self objectOrNilForKey:kMessageRowsReadTime fromDictionary:dict] doubleValue];
            self.cameraCode = [self objectOrNilForKey:kMessageRowsCameraCode fromDictionary:dict];
            self.picturePkid = [self objectOrNilForKey:kMessageRowsPicturePkid fromDictionary:dict];
            self.remark = [self objectOrNilForKey:kMessageRowsRemark fromDictionary:dict];
            self.pictureTimeF = [self objectOrNilForKey:kMessageRowsPictureTimeF fromDictionary:dict];
            self.sendtimeF = [self objectOrNilForKey:kMessageRowsSendtimeF fromDictionary:dict];
            self.readStatus = [[self objectOrNilForKey:kMessageRowsReadStatus fromDictionary:dict] doubleValue];
            self.content = [self objectOrNilForKey:kMessageRowsContent fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kMessageRowsType];
    [mutableDict setValue:self.phone forKey:kMessageRowsPhone];
    [mutableDict setValue:self.cameraPkid forKey:kMessageRowsCameraPkid];
    [mutableDict setValue:self.pkid forKey:kMessageRowsPkid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sendtime] forKey:kMessageRowsSendtime];
    [mutableDict setValue:self.userkey forKey:kMessageRowsUserkey];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pictureTime] forKey:kMessageRowsPictureTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.deleteFlag] forKey:kMessageRowsDeleteFlag];
    [mutableDict setValue:self.address forKey:kMessageRowsAddress];
    [mutableDict setValue:self.pictureDateF forKey:kMessageRowsPictureDateF];
    [mutableDict setValue:[NSNumber numberWithDouble:self.readTime] forKey:kMessageRowsReadTime];
    [mutableDict setValue:self.cameraCode forKey:kMessageRowsCameraCode];
    [mutableDict setValue:self.picturePkid forKey:kMessageRowsPicturePkid];
    [mutableDict setValue:self.remark forKey:kMessageRowsRemark];
    [mutableDict setValue:self.pictureTimeF forKey:kMessageRowsPictureTimeF];
    [mutableDict setValue:self.sendtimeF forKey:kMessageRowsSendtimeF];
    [mutableDict setValue:[NSNumber numberWithDouble:self.readStatus] forKey:kMessageRowsReadStatus];
    [mutableDict setValue:self.content forKey:kMessageRowsContent];

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

    self.type = [aDecoder decodeDoubleForKey:kMessageRowsType];
    self.phone = [aDecoder decodeObjectForKey:kMessageRowsPhone];
    self.cameraPkid = [aDecoder decodeObjectForKey:kMessageRowsCameraPkid];
    self.pkid = [aDecoder decodeObjectForKey:kMessageRowsPkid];
    self.sendtime = [aDecoder decodeDoubleForKey:kMessageRowsSendtime];
    self.userkey = [aDecoder decodeObjectForKey:kMessageRowsUserkey];
    self.pictureTime = [aDecoder decodeDoubleForKey:kMessageRowsPictureTime];
    self.deleteFlag = [aDecoder decodeDoubleForKey:kMessageRowsDeleteFlag];
    self.address = [aDecoder decodeObjectForKey:kMessageRowsAddress];
    self.pictureDateF = [aDecoder decodeObjectForKey:kMessageRowsPictureDateF];
    self.readTime = [aDecoder decodeDoubleForKey:kMessageRowsReadTime];
    self.cameraCode = [aDecoder decodeObjectForKey:kMessageRowsCameraCode];
    self.picturePkid = [aDecoder decodeObjectForKey:kMessageRowsPicturePkid];
    self.remark = [aDecoder decodeObjectForKey:kMessageRowsRemark];
    self.pictureTimeF = [aDecoder decodeObjectForKey:kMessageRowsPictureTimeF];
    self.sendtimeF = [aDecoder decodeObjectForKey:kMessageRowsSendtimeF];
    self.readStatus = [aDecoder decodeDoubleForKey:kMessageRowsReadStatus];
    self.content = [aDecoder decodeObjectForKey:kMessageRowsContent];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_type forKey:kMessageRowsType];
    [aCoder encodeObject:_phone forKey:kMessageRowsPhone];
    [aCoder encodeObject:_cameraPkid forKey:kMessageRowsCameraPkid];
    [aCoder encodeObject:_pkid forKey:kMessageRowsPkid];
    [aCoder encodeDouble:_sendtime forKey:kMessageRowsSendtime];
    [aCoder encodeObject:_userkey forKey:kMessageRowsUserkey];
    [aCoder encodeDouble:_pictureTime forKey:kMessageRowsPictureTime];
    [aCoder encodeDouble:_deleteFlag forKey:kMessageRowsDeleteFlag];
    [aCoder encodeObject:_address forKey:kMessageRowsAddress];
    [aCoder encodeObject:_pictureDateF forKey:kMessageRowsPictureDateF];
    [aCoder encodeDouble:_readTime forKey:kMessageRowsReadTime];
    [aCoder encodeObject:_cameraCode forKey:kMessageRowsCameraCode];
    [aCoder encodeObject:_picturePkid forKey:kMessageRowsPicturePkid];
    [aCoder encodeObject:_remark forKey:kMessageRowsRemark];
    [aCoder encodeObject:_pictureTimeF forKey:kMessageRowsPictureTimeF];
    [aCoder encodeObject:_sendtimeF forKey:kMessageRowsSendtimeF];
    [aCoder encodeDouble:_readStatus forKey:kMessageRowsReadStatus];
    [aCoder encodeObject:_content forKey:kMessageRowsContent];
}

- (id)copyWithZone:(NSZone *)zone
{
    MessageRows *copy = [[MessageRows alloc] init];
    
    if (copy) {

        copy.type = self.type;
        copy.phone = [self.phone copyWithZone:zone];
        copy.cameraPkid = [self.cameraPkid copyWithZone:zone];
        copy.pkid = [self.pkid copyWithZone:zone];
        copy.sendtime = self.sendtime;
        copy.userkey = [self.userkey copyWithZone:zone];
        copy.pictureTime = self.pictureTime;
        copy.deleteFlag = self.deleteFlag;
        copy.address = [self.address copyWithZone:zone];
        copy.pictureDateF = [self.pictureDateF copyWithZone:zone];
        copy.readTime = self.readTime;
        copy.cameraCode = [self.cameraCode copyWithZone:zone];
        copy.picturePkid = [self.picturePkid copyWithZone:zone];
        copy.remark = [self.remark copyWithZone:zone];
        copy.pictureTimeF = [self.pictureTimeF copyWithZone:zone];
        copy.sendtimeF = [self.sendtimeF copyWithZone:zone];
        copy.readStatus = self.readStatus;
        copy.content = [self.content copyWithZone:zone];
    }
    
    return copy;
}


@end
