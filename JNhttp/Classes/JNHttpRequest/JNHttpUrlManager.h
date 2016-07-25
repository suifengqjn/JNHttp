//
//  JNHttpUrlManager.h
//  JNhttp
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNHttpUrlManager : NSObject

+ (instancetype)shareInstance;

- (NSMutableString *)baseUrl;

@end
