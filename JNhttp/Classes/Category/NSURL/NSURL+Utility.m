//
//  NSURL+Parser.m
//  TestPageNavi
//
//  Created by Ryou Zhang on 6/19/13.
//  Copyright (c) 2013 Ryou Zhang. All rights reserved.
//

#import "NSURL+Utility.h"
#import "NSArray+JSON.h"
#import "NSDictionary+JSON.h"
#import "NSArray+Json.h"
#import "NSDictionary+Json.h"
@implementation NSURL(Utility)
+ (NSString *)urlEncodedString:(NSString *)sourceText {
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)sourceText,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
    return result;
}

+ (NSString *)urlDecodingString:(NSString *)sourceText {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                               (CFStringRef) sourceText,
                                                                               CFSTR(""),
                                                                               kCFStringEncodingUTF8));
}

+ (NSString *)parserQueryKey:(NSString *)queryText startIndex:(NSInteger*)startIndex {
    NSInteger length = 0;
    for(NSInteger index = *startIndex; index < [queryText length]; index++) {
        unichar ch = [queryText characterAtIndex:index];
        if (ch == '=') {
            break;
        } else {
            length++;
        }
    }
    NSString *key = [queryText substringWithRange:NSMakeRange(*startIndex, length)];
    *startIndex = *startIndex + length + 1;
    return key;
}

+ (NSString *)parserQueryValue:(NSString *)queryText startIndex:(NSInteger*)startIndex {
    NSInteger length = 0;
    for(NSInteger index = *startIndex; index < [queryText length]; index++) {
        unichar ch = [queryText characterAtIndex:index];
        if (ch == '&') {
            break;
        } else {
            length++;
        }
    }
    NSString *value = [queryText substringWithRange:NSMakeRange(*startIndex, length)];
    *startIndex = *startIndex + length + 1;
    return value;
}

+ (NSMutableDictionary *)parserQueryText:(NSString *)queryText {
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    if (queryText == nil) {
        return paramDic;
    }
    NSInteger index = 0;
    while (true) {
        NSString *key = [NSURL parserQueryKey:queryText startIndex:&index];
        if (index >= [queryText length]) {
            paramDic = nil;
            return nil;
        }
        NSString *value = [NSURL parserQueryValue:queryText startIndex:&index];
        if (key && value) {
            [paramDic setValue:[NSURL urlDecodingString:value]
                        forKey:key];
        }
        if (index >= [queryText length]) {
            break;
        }
    }
    return paramDic;
}

+ (NSString *)generateQueryText:(NSDictionary *)params {
    __block NSMutableString *queryText = [NSMutableString new];
    NSArray *keys = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = [params valueForKey:obj];
        if ([value isKindOfClass:[NSArray class]])
            
            value = [(NSArray *)value JsonString];
        else if ([value isKindOfClass:[NSDictionary class]])
            value = [(NSDictionary *)value JsonString];
        
        if ([queryText length] == 0) {
            [queryText appendFormat:@"%@=%@",
             [NSURL urlEncodedString:obj],
             [NSURL urlEncodedString:[NSString stringWithFormat:@"%@",value]]];
        } else {
            [queryText appendFormat:@"&%@=%@",
             [NSURL urlEncodedString:obj],
             [NSURL urlEncodedString:[NSString stringWithFormat:@"%@",value]]];
        }
    }];
    return queryText;
}
@end
