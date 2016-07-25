//
//  JNHttpService.m
//  JNhttp
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "JNHttpService.h"
#import "JNHttpConfig.h"
#import "JNHttpUrlManager.h"
#import "NSData+Json.h"
@interface JNHttpService()
{
    NSMutableDictionary     *_userAgentConfig;
    NSString                    *_formBoundary;
    
}

@end

@implementation JNHttpService

- (instancetype)init
{
    self = [super init];
    if (self) {
        //NSString * versionBuildString = [NSString stringWithFormat: @"%@(%@)",
        //[[AppEnvironment getInstance] getClientVersion],
        //[[AppEnvironment getInstance] getBuildVersion]];
        //NSString *deviceType = [NSString stringWithDevicePlatform];
        //NSString *osVersion = [UIDevice currentDevice].systemVersion;
        
        NSString *preferredLanguages = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        
        //CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
        //CTCarrier *carrier = [netinfo subscriberCellularProvider];
        
        _userAgentConfig = [NSMutableDictionary new];
        [_userAgentConfig setValue:@"ios" forKey:@"os"];
        //[_userAgentConfig setValue:osVersion forKey:@"os_version"];
        //[_userAgentConfig setValue:versionBuildString forKey:@"app_version"];
        //[_userAgentConfig setValue:deviceType forKey:@"device"];
        [_userAgentConfig setValue:preferredLanguages forKey:@"Accept-Language"];
        //[_userAgentConfig setValue:[[carrier carrierName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"carrier"];
        //[_userAgentConfig setValue:[[JNHttpConfig shareInstance] networkType] forKey:@"network"];
    }
    return self;
}

+ (JNHttpService *)shareInstance
{
    static JNHttpService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (NSURLSessionDataTask *)buildGetTaskWithPath:(NSString * _Nonnull)path
                                 headerParams:(NSDictionary * __nullable)headers
                                  queryParams:(NSDictionary * __nullable)queries
                                      callBack:(void(^ _Nonnull)(id __nullable result, NSError *__nullable error,NSString *__nullable errorMessage))completionHandler
{


    NSURLSession *session  = [[JNHttpConfig shareInstance] buildSession];
    
    NSMutableURLRequest *request = [[JNHttpConfig shareInstance] buildURLRequestWithPath:path
                                                                              HttpMethod:@"GET"
                                                                            HeaderParams:nil
                                                                             QueryParams:queries
                                                                              BodyParams:nil
                                                                            BinaryParams:nil
                                                                              ApiVersion:@"v2"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        id result = [data jsonMObject:error];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"---%@", dict);
        completionHandler(result, error, @"wee");
    }];
    
    return task;
    
}

- (NSURLSessionDataTask *__nullable)buildPostTaskWithPath:(NSString * _Nonnull)path
                                             headerParams:(NSDictionary * __nullable)headers
                                               bodyParams:(NSDictionary * __nullable)bodys
                                                  callBack:(void(^ _Nonnull)(id __nullable result, NSError *__nullable error,NSString *__nullable errorMessage))completionHandler
{
    NSURLSession *session  = [[JNHttpConfig shareInstance] buildSession];
    
    NSMutableURLRequest *request = [[JNHttpConfig shareInstance] buildURLRequestWithPath:path
                                                                              HttpMethod:@"POST"
                                                                            HeaderParams:nil
                                                                             QueryParams:nil
                                                                              BodyParams:bodys
                                                                            BinaryParams:nil
                                                                              ApiVersion:@"v2"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        

        
    }];
    
    return task;
}


#pragma mark - build request
- (NSURLRequest *)buildURLRequestWithPath:(NSString *)path
                               HttpMethod:(NSString *)method
                             HeaderParams:(NSDictionary *)headers
                              QueryParams:(NSDictionary *)queryParams
                               BodyParams:(NSDictionary *)bodyParams
                             BinaryParams:(NSArray *)binaryParams
                               ApiVersion:(NSString *)version
{
    return [[JNHttpConfig shareInstance] buildURLRequestWithPath:path
                                                      HttpMethod:method
                                                    HeaderParams:headers
                                                     QueryParams:queryParams
                                                      BodyParams:bodyParams
                                                    BinaryParams:binaryParams
                                                      ApiVersion:version];
}


@end
