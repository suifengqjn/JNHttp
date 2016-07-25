//
//  JNHttpUrlManager.m
//  JNhttp
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "JNHttpUrlManager.h"

@implementation JNHttpUrlManager

+ (instancetype)shareInstance
{
    static JNHttpUrlManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JNHttpUrlManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSMutableString *)baseUrl
{
    return [NSMutableString stringWithFormat:@"%@", @"http://www.douban.com/j/app/radio/channels"];
}




@end
