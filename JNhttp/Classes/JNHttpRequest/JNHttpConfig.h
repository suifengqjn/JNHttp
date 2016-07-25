//
//  JNHttpConfig.h
//  JNhttp
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNHttpConfig : NSObject

+ (instancetype)shareInstance;

- (NSURLSession *)buildSession;


- (NSMutableURLRequest *)buildURLRequestWithPath:(NSString *)path
                               HttpMethod:(NSString *)method
                             HeaderParams:(NSDictionary *)headers
                              QueryParams:(NSDictionary *)queryParams
                               BodyParams:(NSDictionary *)bodyParams
                             BinaryParams:(NSArray *)binaryParams
                               ApiVersion:(NSString *)version;



//网络类型
- (NSString *)networkType;
@end
