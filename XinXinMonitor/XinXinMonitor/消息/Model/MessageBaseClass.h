//
//  MessageBaseClass.h
//
//  Created by 瑞 孙 on 16/5/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MessageBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double pagenums;
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, assign) double total;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
