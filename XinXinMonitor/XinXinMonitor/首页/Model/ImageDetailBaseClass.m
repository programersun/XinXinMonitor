//
//  ImageDetailBaseClass.m
//
//  Created by 瑞 孙 on 16/5/15
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "ImageDetailBaseClass.h"
#import "ImageDetailRows.h"


NSString *const kImageDetailBaseClassPagenums = @"pagenums";
NSString *const kImageDetailBaseClassRows = @"rows";
NSString *const kImageDetailBaseClassTotal = @"total";


@interface ImageDetailBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ImageDetailBaseClass

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
            self.pagenums = [[self objectOrNilForKey:kImageDetailBaseClassPagenums fromDictionary:dict] doubleValue];
    NSObject *receivedImageDetailRows = [dict objectForKey:kImageDetailBaseClassRows];
    NSMutableArray *parsedImageDetailRows = [NSMutableArray array];
    if ([receivedImageDetailRows isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedImageDetailRows) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedImageDetailRows addObject:[ImageDetailRows modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedImageDetailRows isKindOfClass:[NSDictionary class]]) {
       [parsedImageDetailRows addObject:[ImageDetailRows modelObjectWithDictionary:(NSDictionary *)receivedImageDetailRows]];
    }

    self.rows = [NSArray arrayWithArray:parsedImageDetailRows];
            self.total = [[self objectOrNilForKey:kImageDetailBaseClassTotal fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pagenums] forKey:kImageDetailBaseClassPagenums];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForRows] forKey:kImageDetailBaseClassRows];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kImageDetailBaseClassTotal];

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

    self.pagenums = [aDecoder decodeDoubleForKey:kImageDetailBaseClassPagenums];
    self.rows = [aDecoder decodeObjectForKey:kImageDetailBaseClassRows];
    self.total = [aDecoder decodeDoubleForKey:kImageDetailBaseClassTotal];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_pagenums forKey:kImageDetailBaseClassPagenums];
    [aCoder encodeObject:_rows forKey:kImageDetailBaseClassRows];
    [aCoder encodeDouble:_total forKey:kImageDetailBaseClassTotal];
}

- (id)copyWithZone:(NSZone *)zone
{
    ImageDetailBaseClass *copy = [[ImageDetailBaseClass alloc] init];
    
    if (copy) {

        copy.pagenums = self.pagenums;
        copy.rows = [self.rows copyWithZone:zone];
        copy.total = self.total;
    }
    
    return copy;
}


@end
