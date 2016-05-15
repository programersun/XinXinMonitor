//
//  MonitorListBaseClass.m
//
//  Created by 瑞 孙 on 16/5/14
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MonitorListBaseClass.h"
#import "MonitorListRows.h"


NSString *const kMonitorListBaseClassTotal = @"total";
NSString *const kMonitorListBaseClassRows = @"rows";


@interface MonitorListBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MonitorListBaseClass

@synthesize total = _total;
@synthesize rows = _rows;


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
            self.total = [[self objectOrNilForKey:kMonitorListBaseClassTotal fromDictionary:dict] doubleValue];
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

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kMonitorListBaseClassTotal];
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

    self.total = [aDecoder decodeDoubleForKey:kMonitorListBaseClassTotal];
    self.rows = [aDecoder decodeObjectForKey:kMonitorListBaseClassRows];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_total forKey:kMonitorListBaseClassTotal];
    [aCoder encodeObject:_rows forKey:kMonitorListBaseClassRows];
}

- (id)copyWithZone:(NSZone *)zone
{
    MonitorListBaseClass *copy = [[MonitorListBaseClass alloc] init];
    
    if (copy) {

        copy.total = self.total;
        copy.rows = [self.rows copyWithZone:zone];
    }
    
    return copy;
}


@end
