//
//  NSDictionary+Json.h
//  Adult
//
//  Created by houzhenyong on 14-8-7.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Json)

+ (id)dictionaryWithJsonData:(NSData *)data;
+ (id)dictionaryWithJsonString:(NSString *)string;

- (NSData *)JsonData;
- (NSString *)JsonString;

+ (NSDictionary *)dictionaryWithContentsOfJsonFile:(NSString *)path;
- (BOOL)writeToJsonFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;


@end
