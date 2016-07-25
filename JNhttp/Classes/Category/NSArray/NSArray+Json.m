//
//  NSArray+Json.m
//  test
//
//  Created by stone on 14-9-26.
//  Copyright (c) 2014年 stone. All rights reserved.
//

#import "NSArray+Json.h"

@implementation NSArray (Json)

- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index
{
    if(index >= [self count])
    {
        NSLog(@"invalid index: %ld, count: %ld", (unsigned long)index, (unsigned long)[self count]);
        return nil;
    }
    
    id object = [self objectAtIndex:index];
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        return object;
    }
    
    return nil;
}
+ (id)arrayWithJsonData:(NSData*)data
{
    if(!data)
    {
        NSLog(@"error: data is nil");
        return nil;
    }
    
    NSArray *ret = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if(ret && ![ret isKindOfClass:[NSArray class]])
    {
        NSLog(@"error: data not a NSArray json");
        return nil;
    }
    
    return ret;
}

+ (id)arrayWithJsonString:(NSString *)string
{
    return [NSArray arrayWithJsonData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData*)JsonData
{
    return [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil];
}

- (NSString *)jsonString {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    if (error)
        return nil;
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSArray *)dictionaryWithContentsOfJsonFile:(NSString *)path {
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    if (!jsonData) {
        return nil;
    }
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:0
                                               error:&error];
    if (error || !obj || ![obj isKindOfClass:[NSArray class]]) {
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
