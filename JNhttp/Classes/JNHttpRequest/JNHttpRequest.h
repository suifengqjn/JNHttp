//
//  JNHttpRequest.h
//  JNhttp
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNHttpRequest : NSObject


+ (NSURLSessionTask * __nullable)getWithSuffix:(NSString *__nullable)suffix
                                    parameters:(NSDictionary *__nullable)parameters
                                       callBack:(void(^ _Nonnull)(id __nullable result, NSError *__nullable error,NSString *__nullable errorMessage))completionHandler;

+ (NSURLSessionTask * __nullable)postWithSuffix:(NSString *__nullable)suffix
                                    parameters:(NSDictionary *__nullable)parameters
                                       callBack:(void(^ _Nonnull)(id __nullable result, NSError *__nullable error,NSString *__nullable errorMessage))completionHandler;

@end
