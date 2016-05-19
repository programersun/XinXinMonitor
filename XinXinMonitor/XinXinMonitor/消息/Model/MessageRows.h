//
//  MessageRows.h
//
//  Created by 瑞 孙 on 16/5/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MessageRows : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double type;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *cameraPkid;
@property (nonatomic, strong) NSString *pkid;
@property (nonatomic, assign) double sendtime;
@property (nonatomic, strong) NSString *userkey;
@property (nonatomic, assign) double pictureTime;
@property (nonatomic, assign) double deleteFlag;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *pictureDateF;
@property (nonatomic, assign) double readTime;
@property (nonatomic, strong) NSString *cameraCode;
@property (nonatomic, strong) NSString *picturePkid;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *pictureTimeF;
@property (nonatomic, strong) NSString *sendtimeF;
@property (nonatomic, assign) double readStatus;
@property (nonatomic, strong) NSString *content;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
