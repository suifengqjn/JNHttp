//
//  NSArray+RemoveNSNULL.m
//  http
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "NSArray+RemoveNSNULL.h"
#import "NSSet+RemoveNSNULL.h"
#import "NSDictionary+RemoveNSNULL.h"
@implementation NSArray (RemoveNSNULL)
- (NSMutableArray *)RemoveNSNull{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (id obj in self) {
        id tmp = nil;
        if(![obj isKindOfClass:[NSNull class]]){
            if([obj isKindOfClass:[NSDictionary class]]){
                tmp = [(NSDictionary*)obj RemoveNSNull];
                if(tmp){
                    [array addObject:tmp];
                }
            }else if([obj isKindOfClass:[NSArray class]]){
                tmp = [(NSArray*)obj RemoveNSNull];
                if(tmp){
                    [array addObject:tmp];
                }
            }else if([obj isKindOfClass:[NSSet class]]){
                tmp = [(NSSet*)obj RemoveNSNull];
                if(tmp){
                    [array addObject:tmp];
                }
            }else{
                [array addObject:obj];
            }
        }
    }
    return array;
}
@end
