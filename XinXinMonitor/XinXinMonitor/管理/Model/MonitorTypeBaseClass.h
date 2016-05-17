//
//  MonitorTypeBaseClass.h
//
//  Created by 瑞 孙 on 16/5/17
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MonitorTypeBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double deleteFlag;
@property (nonatomic, assign) double code;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pkid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
