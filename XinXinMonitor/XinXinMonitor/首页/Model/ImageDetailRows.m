//
//  ImageDetailRows.m
//
//  Created by 瑞 孙 on 16/5/15
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "ImageDetailRows.h"


NSString *const kImageDetailRowsCompareTime = @"compare_time";
NSString *const kImageDetailRowsPictureTime = @"picture_time";
NSString *const kImageDetailRowsPkid = @"pkid";
NSString *const kImageDetailRowsUrl = @"url";
NSString *const kImageDetailRowsUsersetResult = @"userset_result";
NSString *const kImageDetailRowsDeleteFlag = @"delete_flag";
NSString *const kImageDetailRowsUsersetUserkey = @"userset_userkey";
NSString *const kImageDetailRowsRemark = @"remark";
NSString *const kImageDetailRowsComparePkid = @"compare_pkid";
NSString *const kImageDetailRowsCameraCode = @"camera_code";
NSString *const kImageDetailRowsResult = @"result";
NSString *const kImageDetailRowsCreateTime = @"create_time";
NSString *const kImageDetailRowsUsersetTime = @"userset_time";
NSString *const kImageDetailRowsUsersetUsername = @"userset_username";


@interface ImageDetailRows ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ImageDetailRows

@synthesize compareTime = _compareTime;
@synthesize pictureTime = _pictureTime;
@synthesize pkid = _pkid;
@synthesize url = _url;
@synthesize usersetResult = _usersetResult;
@synthesize deleteFlag = _deleteFlag;
@synthesize usersetUserkey = _usersetUserkey;
@synthesize remark = _remark;
@synthesize comparePkid = _comparePkid;
@synthesize cameraCode = _cameraCode;
@synthesize result = _result;
@synthesize createTime = _createTime;
@synthesize usersetTime = _usersetTime;
@synthesize usersetUsername = _usersetUsername;


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
            self.compareTime = [[self objectOrNilForKey:kImageDetailRowsCompareTime fromDictionary:dict] doubleValue];
            self.pictureTime = [self objectOrNilForKey:kImageDetailRowsPictureTime fromDictionary:dict];
            self.pkid = [self objectOrNilForKey:kImageDetailRowsPkid fromDictionary:dict];
            self.url = [self objectOrNilForKey:kImageDetailRowsUrl fromDictionary:dict];
            self.usersetResult = [[self objectOrNilForKey:kImageDetailRowsUsersetResult fromDictionary:dict] doubleValue];
            self.deleteFlag = [[self objectOrNilForKey:kImageDetailRowsDeleteFlag fromDictionary:dict] doubleValue];
            self.usersetUserkey = [self objectOrNilForKey:kImageDetailRowsUsersetUserkey fromDictionary:dict];
            self.remark = [self objectOrNilForKey:kImageDetailRowsRemark fromDictionary:dict];
            self.comparePkid = [self objectOrNilForKey:kImageDetailRowsComparePkid fromDictionary:dict];
            self.cameraCode = [self objectOrNilForKey:kImageDetailRowsCameraCode fromDictionary:dict];
            self.result = [[self objectOrNilForKey:kImageDetailRowsResult fromDictionary:dict] doubleValue];
            self.createTime = [[self objectOrNilForKey:kImageDetailRowsCreateTime fromDictionary:dict] doubleValue];
            self.usersetTime = [self objectOrNilForKey:kImageDetailRowsUsersetTime fromDictionary:dict];
            self.usersetUsername = [self objectOrNilForKey:kImageDetailRowsUsersetUsername fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.compareTime] forKey:kImageDetailRowsCompareTime];
    [mutableDict setValue:self.pictureTime forKey:kImageDetailRowsPictureTime];
    [mutableDict setValue:self.pkid forKey:kImageDetailRowsPkid];
    [mutableDict setValue:self.url forKey:kImageDetailRowsUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.usersetResult] forKey:kImageDetailRowsUsersetResult];
    [mutableDict setValue:[NSNumber numberWithDouble:self.deleteFlag] forKey:kImageDetailRowsDeleteFlag];
    [mutableDict setValue:self.usersetUserkey forKey:kImageDetailRowsUsersetUserkey];
    [mutableDict setValue:self.remark forKey:kImageDetailRowsRemark];
    [mutableDict setValue:self.comparePkid forKey:kImageDetailRowsComparePkid];
    [mutableDict setValue:self.cameraCode forKey:kImageDetailRowsCameraCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.result] forKey:kImageDetailRowsResult];
    [mutableDict setValue:[NSNumber numberWithDouble:self.createTime] forKey:kImageDetailRowsCreateTime];
    [mutableDict setValue:self.usersetTime forKey:kImageDetailRowsUsersetTime];
    [mutableDict setValue:self.usersetUsername forKey:kImageDetailRowsUsersetUsername];

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

    self.compareTime = [aDecoder decodeDoubleForKey:kImageDetailRowsCompareTime];
    self.pictureTime = [aDecoder decodeObjectForKey:kImageDetailRowsPictureTime];
    self.pkid = [aDecoder decodeObjectForKey:kImageDetailRowsPkid];
    self.url = [aDecoder decodeObjectForKey:kImageDetailRowsUrl];
    self.usersetResult = [aDecoder decodeDoubleForKey:kImageDetailRowsUsersetResult];
    self.deleteFlag = [aDecoder decodeDoubleForKey:kImageDetailRowsDeleteFlag];
    self.usersetUserkey = [aDecoder decodeObjectForKey:kImageDetailRowsUsersetUserkey];
    self.remark = [aDecoder decodeObjectForKey:kImageDetailRowsRemark];
    self.comparePkid = [aDecoder decodeObjectForKey:kImageDetailRowsComparePkid];
    self.cameraCode = [aDecoder decodeObjectForKey:kImageDetailRowsCameraCode];
    self.result = [aDecoder decodeDoubleForKey:kImageDetailRowsResult];
    self.createTime = [aDecoder decodeDoubleForKey:kImageDetailRowsCreateTime];
    self.usersetTime = [aDecoder decodeObjectForKey:kImageDetailRowsUsersetTime];
    self.usersetUsername = [aDecoder decodeObjectForKey:kImageDetailRowsUsersetUsername];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_compareTime forKey:kImageDetailRowsCompareTime];
    [aCoder encodeObject:_pictureTime forKey:kImageDetailRowsPictureTime];
    [aCoder encodeObject:_pkid forKey:kImageDetailRowsPkid];
    [aCoder encodeObject:_url forKey:kImageDetailRowsUrl];
    [aCoder encodeDouble:_usersetResult forKey:kImageDetailRowsUsersetResult];
    [aCoder encodeDouble:_deleteFlag forKey:kImageDetailRowsDeleteFlag];
    [aCoder encodeObject:_usersetUserkey forKey:kImageDetailRowsUsersetUserkey];
    [aCoder encodeObject:_remark forKey:kImageDetailRowsRemark];
    [aCoder encodeObject:_comparePkid forKey:kImageDetailRowsComparePkid];
    [aCoder encodeObject:_cameraCode forKey:kImageDetailRowsCameraCode];
    [aCoder encodeDouble:_result forKey:kImageDetailRowsResult];
    [aCoder encodeDouble:_createTime forKey:kImageDetailRowsCreateTime];
    [aCoder encodeObject:_usersetTime forKey:kImageDetailRowsUsersetTime];
    [aCoder encodeObject:_usersetUsername forKey:kImageDetailRowsUsersetUsername];
}

- (id)copyWithZone:(NSZone *)zone
{
    ImageDetailRows *copy = [[ImageDetailRows alloc] init];
    
    if (copy) {

        copy.compareTime = self.compareTime;
        copy.pictureTime = [self.pictureTime copyWithZone:zone];
        copy.pkid = [self.pkid copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.usersetResult = self.usersetResult;
        copy.deleteFlag = self.deleteFlag;
        copy.usersetUserkey = [self.usersetUserkey copyWithZone:zone];
        copy.remark = [self.remark copyWithZone:zone];
        copy.comparePkid = [self.comparePkid copyWithZone:zone];
        copy.cameraCode = [self.cameraCode copyWithZone:zone];
        copy.result = self.result;
        copy.createTime = self.createTime;
        copy.usersetTime = [self.usersetTime copyWithZone:zone];
        copy.usersetUsername = [self.usersetUsername copyWithZone:zone];
    }
    
    return copy;
}


@end
