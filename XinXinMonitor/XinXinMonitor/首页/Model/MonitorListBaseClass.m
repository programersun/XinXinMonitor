//
//  MonitorListBaseClass.m
//
//  Created by 瑞 孙 on 16/6/10
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MonitorListBaseClass.h"
#import "MonitorListRows.h"


NSString *const kMonitorListBaseClassPagenums = @"pagenums";
NSString *const kMonitorListBaseClassRows = @"rows";
NSString *const kMonitorListBaseClassTotal = @"total";


@interface MonitorListBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MonitorListBaseClass

@synthesize pagenums = _pagenums;
@synthesize rows = _rows;
@synthesize total = _total;


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
            self.pagenums = [[self objectOrNilForKey:kMonitorListBaseClassPagenums fromDictionary:dict] doubleValue];
    NSObject *receivedMonitorListRows = [dict objectForKey:kMonitorListBaseClassRows];
    NSMutableArray *parsedMonitorListRows = [NSMutableArray array];
    if ([receivedMonitorListRows isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedMonitorListRows) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedMonitorListRows addObject:[MonitorListRows modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedMonitorListRows isKindOfClass:[NSDictionary class]]) {
       [parsedMonitorListRows addObject:[MonitorListRows modelObjectWithDictionary:(NSDictionary *)receivedMonitorListRows]];
    }

    self.rows = [NSArray arrayWithArray:parsedMonitorListRows];
            self.total = [[self objectOrNilForKey:kMonitorListBaseClassTotal fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pagenums] forKey:kMonitorListBaseClassPagenums];
    NSMutableArray *tempArrayForRows = [NSMutableArray array];
    for (NSObject *subArrayObject in self.rows) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForRows addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForRows addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForRows] forKey:kMonitorListBaseClassRows];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kMonitorListBaseClassTotal];

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

    self.pagenums = [aDecoder decodeDoubleForKey:kMonitorListBaseClassPagenums];
    self.rows = [aDecoder decodeObjectForKey:kMonitorListBaseClassRows];
    self.total = [aDecoder decodeDoubleForKey:kMonitorListBaseClassTotal];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_pagenums forKey:kMonitorListBaseClassPagenums];
    [aCoder encodeObject:_rows forKey:kMonitorListBaseClassRows];
    [aCoder encodeDouble:_total forKey:kMonitorListBaseClassTotal];
}

- (id)copyWithZone:(NSZone *)zone
{
    MonitorListBaseClass *copy = [[MonitorListBaseClass alloc] init];
    
    if (copy) {

        copy.pagenums = self.pagenums;
        copy.rows = [self.rows copyWithZone:zone];
        copy.total = self.total;
    }
    
    return copy;
}


@end
