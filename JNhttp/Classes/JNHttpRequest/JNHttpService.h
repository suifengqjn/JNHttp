//
//  JNHttpService.h
//  JNhttp
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNHttpService : NSObject

+ (JNHttpService * _Nonnull)shareInstance;

- (NSURLSessionTask *__nullable)buildGetTaskWithPath:(NSString * _Nonnull)path
                                 headerParams:(NSDictionary * __nullable)headers
                                  queryParams:(NSDictionary * __nullable)queries
                                      callBack:(void(^ _Nonnull)(id __nullable result, NSError *__nullable error,NSString *__nullable errorMessage))completionHandler;

- (NSURLSessionTask *__nullable)buildPostTaskWithPath:(NSString * _Nonnull)path
                                    headerParams:(NSDictionary * __nullable)headers
                                     bodyParams:(NSDictionary * __nullable)bodys
                                         callBack:(void(^ _Nonnull)(id __nullable result, NSError *__nullable error,NSString *__nullable errorMessage))completionHandler;
@end
