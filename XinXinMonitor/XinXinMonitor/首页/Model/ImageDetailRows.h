//
//  ImageDetailRows.h
//
//  Created by 瑞 孙 on 16/5/15
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ImageDetailRows : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double compareTime;
@property (nonatomic, strong) NSString *pictureTime;
@property (nonatomic, strong) NSString *pkid;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) double usersetResult;
@property (nonatomic, assign) double deleteFlag;
@property (nonatomic, strong) NSString *usersetUserkey;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *comparePkid;
@property (nonatomic, strong) NSString *cameraCode;
@property (nonatomic, assign) double result;
@property (nonatomic, assign) double createTime;
@property (nonatomic, strong) NSString *usersetTime;
@property (nonatomic, strong) NSString *usersetUsername;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
