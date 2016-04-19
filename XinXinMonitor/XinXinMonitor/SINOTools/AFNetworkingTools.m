//
//  AFNetworkingTools.m
//  BaseViewController
//
//  Created by 孙瑞 on 16/3/21.
//  Copyright © 2016年 孙瑞. All rights reserved.
//

#import "AFNetworkReachabilityManager.h"
#import "AFNetworkingTools.h"

@interface AFNetworkingTools ()<NSCopying>

@end

@implementation AFNetworkingTools

static AFNetworkingTools *sharedManager = nil;
+ (instancetype)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [AFNetworkingTools manager];
    sharedManager.requestSerializer.timeoutInterval = 20.0;
    sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
    sharedManager.responseSerializer.acceptableContentTypes =
        [NSSet setWithObjects:@"text/json", @"text/html", @"application/json",
                              @"text/javascript", @"text/plain", nil];
  });
  return sharedManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [super allocWithZone:zone];
  });
  return sharedManager;
}

- (id)copyWithZone:(NSZone *)zone {
  return sharedManager;
}

+ (void)GetRequsetWithUrl:(NSString *)url
                   params:(NSDictionary *)params
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure {
  if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"NetWorkConnect"]
          isEqualToString:@"NONetWork"]) {
    [self cancelRequest];
    if ([AFNetworkingTools sharedManager].noNetworkBlock) {
      [AFNetworkingTools sharedManager].noNetworkBlock();
    }
  } else {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[AFNetworkingTools sharedManager] GET:url
        parameters:params
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
          if (success) {
            success(responseObject);
          }

        }
        failure:^(NSURLSessionDataTask *_Nullable task,
                  NSError *_Nonnull error) {
          if (failure) {
            failure(error);
          }
        }];
  }
}

+ (void)PostRequsetWithUrl:(NSString *)url
                    params:(NSDictionary *)params
                   success:(void (^)(id))success
                   failure:(void (^)(NSError *))failure {
  if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"NetWorkConnect"]
          isEqualToString:@"NONetWork"]) {
    [self cancelRequest];

    if ([AFNetworkingTools sharedManager].noNetworkBlock) {
      [AFNetworkingTools sharedManager].noNetworkBlock();
    }

  } else {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[AFNetworkingTools sharedManager] POST:url
        parameters:params
        progress:^(NSProgress *_Nonnull uploadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
          if (success) {
            success(responseObject);
          }
        }
        failure:^(NSURLSessionDataTask *_Nullable task,
                  NSError *_Nonnull error) {
          if (failure) {
            failure(error);
          }
        }];
  }
}

+ (void)PostImageWithFormData:(NSString *)url
                       params:(NSDictionary *)params
                   imageArray:(NSArray *)imageArray
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *))failure {
  if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"NetWorkConnect"]
          isEqualToString:@"NONetWork"]) {
    [self cancelRequest];
    if ([AFNetworkingTools sharedManager].noNetworkBlock) {
      [AFNetworkingTools sharedManager].noNetworkBlock();
    }
  } else {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[AFNetworkingTools sharedManager] POST:url
        parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
          for (int i = 0; i < imageArray.count; i++) {
            UIImage *image = [imageArray objectAtIndex:i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];

            [formData appendPartWithFileData:imageData
                                        name:@"image"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
          }
        }
        progress:^(NSProgress *_Nonnull uploadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
          if (success) {
            success(responseObject);
          }
        }
        failure:^(NSURLSessionDataTask *_Nullable task,
                  NSError *_Nonnull error) {
          if (failure) {
            failure(error);
          }
        }];
  }
}

+ (void)cancelRequest {
  [[AFNetworkingTools sharedManager].operationQueue cancelAllOperations];
}

#pragma mark 处理网络状态改变
- (void)networkStateChange {
  [[AFNetworkReachabilityManager sharedManager] startMonitoring];
  [[AFNetworkReachabilityManager sharedManager]
      setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (AFNetworkReachabilityStatusReachableViaWiFi == status) {
          [[NSUserDefaults standardUserDefaults] setValue:@"WIFY"
                                                   forKey:@"NetWorkConnect"];
          [[NSUserDefaults standardUserDefaults] synchronize];
        } else if (AFNetworkReachabilityStatusReachableViaWWAN == status) {
          [[NSUserDefaults standardUserDefaults] setValue:@"WWAN"
                                                   forKey:@"NetWorkConnect"];
          [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
          [[NSUserDefaults standardUserDefaults] setValue:@"NONetWork"
                                                   forKey:@"NetWorkConnect"];
          [[NSUserDefaults standardUserDefaults] synchronize];
        }
      }];
}

@end
