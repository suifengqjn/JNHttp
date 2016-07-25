//
//  NSDictionary+Json.m
//  Adult
//
//  Created by houzhenyong on 14-8-7.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "NSDictionary+Json.h"

@implementation NSDictionary (Json)

+ (id)dictionaryWithJsonData:(NSData*)data
{
    if(!data)
    {
        NSLog(@"error: data is nil");
        return nil;
    }
    
    NSDictionary *ret = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if(ret && ![ret isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"error: data not a NSDictionary json");
        return nil;
    }
    
    return ret;
}

+ (id)dictionaryWithJsonString:(NSString *)string
{
    return [NSDictionary dictionaryWithJsonData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData*)JsonData
{
    return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
}

- (NSString*)JsonString
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    
    return jsonString;
}

+ (NSDictionary *)dictionaryWithContentsOfJsonFile:(NSString *)path {
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    if (!jsonData) {
        return nil;
    }
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:0
                                               error:&error];
    if (error || !obj || ![obj isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return obj;
}

- (BOOL)writeToJsonFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    if (error)
        return NO;
    
    return [jsonData writeToFile:path atomically:useAuxiliaryFile];
}


@end
