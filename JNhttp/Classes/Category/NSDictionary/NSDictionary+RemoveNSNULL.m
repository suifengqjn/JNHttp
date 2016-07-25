//
//  NSDictionary+RemoveNSNULL.m
//  http
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "NSDictionary+RemoveNSNULL.h"
#import "NSSet+RemoveNSNULL.h"
#import "NSArray+RemoveNSNULL.h"
@implementation NSDictionary (RemoveNSNULL)
- (NSMutableDictionary *)RemoveNSNull{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:[self count]];
    for (NSString *key in [self allKeys]) {
        id obj = [self valueForKey:key];
        id tmp = nil;
        if(![obj isKindOfClass:[NSNull class]]){
            if([obj isKindOfClass:[NSDictionary class]]){
                tmp = [(NSDictionary*)obj RemoveNSNull];
                if(tmp){
                    [dic setValue:tmp forKeyPath:key];
                }
            }else if([obj isKindOfClass:[NSArray class]]){
                tmp = [(NSArray*)obj RemoveNSNull];
                if(tmp){
                    [dic setValue:tmp forKeyPath:key];
                }
            }else if([obj isKindOfClass:[NSSet class]]){
                tmp = [(NSSet*)obj RemoveNSNull];
                if(tmp){
                    [dic setValue:tmp forKeyPath:key];
                }
            }else if([obj isKindOfClass:[NSString class]]){
                if ([obj length] > 0) {
                    [dic setValue:obj forKeyPath:key];
                }
            }else {
                [dic setValue:obj forKeyPath:key];
            }
        }
    }
    return dic;
}
@end
