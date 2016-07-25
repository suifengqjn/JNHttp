//
//  JNHttpRequest.m
//  JNhttp
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "JNHttpRequest.h"
#import "JNHttpService.h"
@implementation JNHttpRequest

+ (NSURLSessionTask * __nullable)getWithSuffix:(NSString *__nullable)suffix
                                    parameters:(NSDictionary *__nullable)parameters
                                       callBack:(void(^ _Nonnull)(id __nullable result, NSError *__nullable error,NSString *__nullable errorMessage))completionHandler
{
    NSURLSessionTask *task = [[JNHttpService shareInstance] buildGetTaskWithPath:suffix headerParams:nil queryParams:parameters callBack:completionHandler];
    
    [task resume];
    return task;
}

+ (NSURLSessionTask * __nullable)postWithSuffix:(NSString *__nullable)suffix
                                     parameters:(NSDictionary *__nullable)parameters
                                        callBack:(void(^ _Nonnull)(id __nullable result, NSError *__nullable error,NSString *__nullable errorMessage))completionHandler
{
    NSURLSessionTask *task =  [[JNHttpService shareInstance] buildPostTaskWithPath:suffix headerParams:nil bodyParams:parameters callBack:completionHandler];
    [task resume];
    
    return task;
}
@end
