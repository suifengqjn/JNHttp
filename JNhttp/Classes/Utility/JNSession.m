//
//  JNSession.m
//  JNhttp
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "JNSession.h"

NSString *const JNSessionLoginNotification = @"JNSessionLoginNotification";
NSString *const JNSessionLogoutNotification = @"JNSessionLogoutNotification";
@interface JNSession()
{
    NSMutableDictionary *_sessionInfo;
}
@end

@implementation JNSession

+(JNSession *)shareInstance
{
    static JNSession *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JNSession alloc] init];
    });
    
    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        id cachedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"JNSession"];
        if ([cachedData isKindOfClass:[NSDictionary class]]) {
            _sessionInfo = [NSMutableDictionary new];
            [_sessionInfo setValuesForKeysWithDictionary:cachedData];
        }
    }
    return self;
}

- (BOOL)isLogin {
    @synchronized(self) {
        return _sessionInfo != nil;
    }
}

- (void)logout {
    @synchronized(self) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"JNSession"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _sessionInfo = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:JNSessionLogoutNotification
                                                            object:self];
    }
}
@end
