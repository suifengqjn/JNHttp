//
//  NSData+Json.m
//  http
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "NSData+Json.h"
#import "NSSet+RemoveNSNULL.h"
#import "NSArray+RemoveNSNULL.h"
#import "NSDictionary+RemoveNSNULL.h"
@implementation NSData (Json)
- (id)jsonMObject:(NSError *)error {
    id result = [NSJSONSerialization JSONObjectWithData:self
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    if (error || [NSJSONSerialization isValidJSONObject:result] == NO)
        return nil;
    
    return [result RemoveNSNull];
}
@end
