//
//  MessageBaseClass.m
//
//  Created by 瑞 孙 on 16/5/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "MessageBaseClass.h"
#import "MessageRows.h"


NSString *const kMessageBaseClassPagenums = @"pagenums";
NSString *const kMessageBaseClassRows = @"rows";
NSString *const kMessageBaseClassTotal = @"total";


@interface MessageBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation MessageBaseClass

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
            self.pagenums = [[self objectOrNilForKey:kMessageBaseClassPagenums fromDictionary:dict] doubleValue];
    NSObject *receivedMessageRows = [dict objectForKey:kMessageBaseClassRows];
    NSMutableArray *parsedMessageRows = [NSMutableArray array];
    if ([receivedMessageRows isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedMessageRows) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedMessageRows addObject:[MessageRows modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedMessageRows isKindOfClass:[NSDictionary class]]) {
       [parsedMessageRows addObject:[MessageRows modelObjectWithDictionary:(NSDictionary *)receivedMessageRows]];
    }

    self.rows = [NSArray arrayWithArray:parsedMessageRows];
            self.total = [[self objectOrNilForKey:kMessageBaseClassTotal fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pagenums] forKey:kMessageBaseClassPagenums];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForRows] forKey:kMessageBaseClassRows];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kMessageBaseClassTotal];

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

    self.pagenums = [aDecoder decodeDoubleForKey:kMessageBaseClassPagenums];
    self.rows = [aDecoder decodeObjectForKey:kMessageBaseClassRows];
    self.total = [aDecoder decodeDoubleForKey:kMessageBaseClassTotal];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_pagenums forKey:kMessageBaseClassPagenums];
    [aCoder encodeObject:_rows forKey:kMessageBaseClassRows];
    [aCoder encodeDouble:_total forKey:kMessageBaseClassTotal];
}

- (id)copyWithZone:(NSZone *)zone
{
    MessageBaseClass *copy = [[MessageBaseClass alloc] init];
    
    if (copy) {

        copy.pagenums = self.pagenums;
        copy.rows = [self.rows copyWithZone:zone];
        copy.total = self.total;
    }
    
    return copy;
}


@end
