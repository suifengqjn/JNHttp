//
//  NSSet+RemoveNSNULL.m
//  http
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "NSSet+RemoveNSNULL.h"
#import "NSArray+RemoveNSNULL.h"
#import "NSDictionary+RemoveNSNULL.h"
@implementation NSSet (RemoveNSNULL)
- (NSMutableSet *)RemoveNSNull{
    NSMutableSet *set = [[NSMutableSet alloc] initWithCapacity:[self count]];
    for (id obj in [set allObjects]) {
        id tmp = nil;
        if(![obj isKindOfClass:[NSNull class]]){
            if([obj isKindOfClass:[NSDictionary class]]){
                tmp = [(NSDictionary*)obj RemoveNSNull];
                if(tmp){
                    [set addObject:tmp];
                }
            }else if([obj isKindOfClass:[NSArray class]]){
                tmp = [(NSArray*)obj RemoveNSNull];
                if(tmp){
                    [set addObject:tmp];
                }
            }else if([obj isKindOfClass:[NSSet class]]){
                tmp = [(NSSet*)obj RemoveNSNull];
                if(tmp){
                    [set addObject:tmp];
                }
            }else{
                [set addObject:obj];
            }
        }
    }
    return set;
}
@end
