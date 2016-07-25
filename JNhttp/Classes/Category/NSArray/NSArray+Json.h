//
//  NSArray+Json.h
//  test
//
//  Created by stone on 14-9-26.
//  Copyright (c) 2014年 stone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Json)

- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index;

+ (id)arrayWithJsonString:(NSString*)string;
+ (id)arrayWithJsonData:(NSData *)data;
- (NSString *)JsonString;
- (NSData *)JsonData;

+ (NSArray *)dictionaryWithContentsOfJsonFile:(NSString *)path;
- (BOOL)writeToJsonFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

@end
