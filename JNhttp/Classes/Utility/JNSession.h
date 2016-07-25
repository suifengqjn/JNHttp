//
//  JNSession.h
//  JNhttp
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const JNSessionLoginNotification;
FOUNDATION_EXPORT NSString *const JNSessionLogoutNotification;

@interface JNSession : NSObject

@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *userToken;
@property(nonatomic, copy) NSString *userEmail;
@property(nonatomic, copy) NSString *userPhoneNumber;
@property(nonatomic, copy) NSString *userName;

+ (JNSession *)shareInstance;
- (BOOL)isLogin;
- (void)logout;

@end
