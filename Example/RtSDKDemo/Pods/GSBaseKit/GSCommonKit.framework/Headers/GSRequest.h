//
//  GSRequest.h
//  GSCommonKit
//
//  Created by Sheng on 2018/8/29.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSRequest : NSObject

@property (nonatomic, assign) BOOL isAlwaysTrustCertificate; //是否总是信任证书 https模式下有效

+ (nullable NSURLSessionDataTask *)HTTPMethod:(NSString *)method
                                    URLString:(NSString *)URLString
                                   parameters:(nullable id)parameters
                                      headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                      success:(nullable void (^)(id _Nullable responseObject))success
                                      failure:(nullable void (^)(NSError *error))failure;

- (nullable NSURLSessionDataTask *)HTTPMethod:(NSString *)method
                                    URLString:(NSString *)URLString
                                   parameters:(nullable id)parameters
                                      headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                      success:(nullable void (^)(id _Nullable responseObject))success
                                      failure:(nullable void (^)(NSError *error))failure;

@end
