//
//  MonitorTypeBaseClass.m
//
//  Created by 瑞 孙 on 16/5/17
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MonitorTypeBaseClass.h"


NSString *const kMonitorTypeBaseClassDeleteFlag = @"delete_flag";
NSString *const kMonitorTypeBaseClassCode = @"code";
NSString *const kMonitorTypeBaseClassRemark = @"remark";
NSString *const kMonitorTypeBaseClassName = @"name";
NSString *const kMonitorTypeBaseClassPkid = @"pkid";


@interface MonitorTypeBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MonitorTypeBaseClass

@synthesize deleteFlag = _deleteFlag;
@synthesize code = _code;
@synthesize remark = _remark;
@synthesize name = _name;
@synthesize pkid = _pkid;


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
            self.deleteFlag = [[self objectOrNilForKey:kMonitorTypeBaseClassDeleteFlag fromDictionary:dict] doubleValue];
            self.code = [[self objectOrNilForKey:kMonitorTypeBaseClassCode fromDictionary:dict] doubleValue];
            self.remark = [self objectOrNilForKey:kMonitorTypeBaseClassRemark fromDictionary:dict];
            self.name = [self objectOrNilForKey:kMonitorTypeBaseClassName fromDictionary:dict];
            self.pkid = [self objectOrNilForKey:kMonitorTypeBaseClassPkid fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.deleteFlag] forKey:kMonitorTypeBaseClassDeleteFlag];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kMonitorTypeBaseClassCode];
    [mutableDict setValue:self.remark forKey:kMonitorTypeBaseClassRemark];
    [mutableDict setValue:self.name forKey:kMonitorTypeBaseClassName];
    [mutableDict setValue:self.pkid forKey:kMonitorTypeBaseClassPkid];

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

    self.deleteFlag = [aDecoder decodeDoubleForKey:kMonitorTypeBaseClassDeleteFlag];
    self.code = [aDecoder decodeDoubleForKey:kMonitorTypeBaseClassCode];
    self.remark = [aDecoder decodeObjectForKey:kMonitorTypeBaseClassRemark];
    self.name = [aDecoder decodeObjectForKey:kMonitorTypeBaseClassName];
    self.pkid = [aDecoder decodeObjectForKey:kMonitorTypeBaseClassPkid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_deleteFlag forKey:kMonitorTypeBaseClassDeleteFlag];
    [aCoder encodeDouble:_code forKey:kMonitorTypeBaseClassCode];
    [aCoder encodeObject:_remark forKey:kMonitorTypeBaseClassRemark];
    [aCoder encodeObject:_name forKey:kMonitorTypeBaseClassName];
    [aCoder encodeObject:_pkid forKey:kMonitorTypeBaseClassPkid];
}

- (id)copyWithZone:(NSZone *)zone
{
    MonitorTypeBaseClass *copy = [[MonitorTypeBaseClass alloc] init];
    
    if (copy) {

        copy.deleteFlag = self.deleteFlag;
        copy.code = self.code;
        copy.remark = [self.remark copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.pkid = [self.pkid copyWithZone:zone];
    }
    
    return copy;
}


@end
