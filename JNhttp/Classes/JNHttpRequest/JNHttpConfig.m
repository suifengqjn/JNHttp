//
//  JNHttpConfig.m
//  JNhttp
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "JNHttpConfig.h"
#import <UIKit/UIKit.h>
#import "JNHttpUrlManager.h"
#import "NSString+Hash.h"
#import "NSURL+Utility.h"
#import "JNSession.h"
#import <AdSupport/ASIdentifierManager.h>
@interface JNHttpConfig()
{
    NSURLSession *_session;
    NSString     *_formBoundary;
    NSMutableDictionary     *_userAgentConfig;
}
@end

@implementation JNHttpConfig


+ (instancetype)shareInstance
{
    static JNHttpConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.HTTPMaximumConnectionsPerHost = 8; //连接到特定主机的数量
        sessionConfig.timeoutIntervalForRequest = 30; //超时时间
        sessionConfig.discretionary = YES;           // 网络自行决定，建议在后台的时候自行决定
        sessionConfig.sessionSendsLaunchEvents = NO; //一个新的属性，该属性指定该会话是否应该从后台启动
        _session = [NSURLSession sessionWithConfiguration:sessionConfig];
        
        
        _formBoundary = [[NSUUID UUID] UUIDString];
        
        
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

- (NSURLSession *)buildSession
{
    return _session;
}

- (NSMutableURLRequest *)buildURLRequestWithPath:(NSString *)path
                               HttpMethod:(NSString *)method
                             HeaderParams:(NSDictionary *)headers
                              QueryParams:(NSDictionary *)queryParams
                               BodyParams:(NSDictionary *)bodyParams
                             BinaryParams:(NSArray *)binaryParams
                               ApiVersion:(NSString *)version
{
    NSMutableString *urlStr = [[JNHttpUrlManager shareInstance] baseUrl];
    
    //append version to api path
//    if (version) {
//        [urlStr appendFormat:@"/%@", version];
//    }
//    if (path) {
//        [urlStr appendString:path];
//    }
    
    
    
    //orgernize params for sign
    NSMutableDictionary *params = nil;
    if (queryParams) {
        params = [NSMutableDictionary dictionaryWithDictionary:queryParams];
    } else {
        params = [NSMutableDictionary dictionaryWithDictionary:bodyParams];
    }
    
    //append timestamp to params
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970] * 1000;
    [params setValue:[NSString stringWithFormat:@"%.0f", ts] forKey:@"ts"];
    
    //add sign
    NSString *sign = [self signWithMethod:method Url:urlStr queries:params];
    [params setValue:sign forKey:@"sign"];
    
    
    //build url
    NSDictionary *requestParams = nil;
    if ([@"GET" isEqualToString:method]) {
        requestParams = params;
    }
    NSURL *url = nil;
    if (requestParams) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",
                                    urlStr,
                                    [NSURL generateQueryText:queryParams]]];
    } else {
        url = [NSURL URLWithString:urlStr];
    }
    
    //build request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = method;
    
    NSDictionary *headerParams = [self buildHttpHeaders:headers];
    if(binaryParams){
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", _formBoundary];
        [(NSMutableDictionary *)headerParams setValue:contentType forKey:@"Content-Type"];
    }
//    for (NSString *key in headerParams.allKeys) {
//        [request setValue:headerParams[key] forHTTPHeaderField:key];
//    }
    
    NSDictionary *PostParams = nil;
    if ([@"POST" isEqualToString:method]) {
        PostParams = params;
        if (!binaryParams) {
            NSMutableString *queryStr = [NSMutableString new];
            for (NSString *key in PostParams.allKeys) {
                if (queryStr.length == 0) {
                }else{
                    [queryStr appendString:@"&"];
                }
                [queryStr appendFormat:@"%@=%@", key, [NSURL urlEncodedString:[[bodyParams valueForKey:key] description]]];
            }
            request.HTTPBody = [queryStr dataUsingEncoding:NSUTF8StringEncoding];
        }else{
            request.HTTPBody = [self createBodyWithBoundary:_formBoundary parameters:bodyParams binaryData:binaryParams];
        }
    }
    
    return request;
    
    

}





#pragma mark Utils

#pragma mark - 签名
- (NSString *)signWithMethod:(NSString *)method Url:(NSString *)url queries:(NSDictionary *)qParams {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValuesForKeysWithDictionary:qParams];
    NSArray *sortedKeyList = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *query = [NSMutableString new];
    for (NSString *key in sortedKeyList) {
        if(query.length > 0){
            [query appendString:@"&"];
        }
        [query appendFormat:@"%@=%@", key, [params valueForKey:key]];
    }
    NSString *raw = [@[method, url, query, @"Ad$iOI34erwer"] componentsJoinedByString:@"&"];
    
    return [raw hmacSHA1StringWithKey:@"Ad$iOI34erwer"];
    
}


#pragma mark - headerparams
- (NSDictionary * __nullable)buildHttpHeaders:(NSDictionary * __nullable)headerParams
{
    NSMutableDictionary *header = [NSMutableDictionary new];
    NSString *accessToken = [JNSession shareInstance].userToken;
    if (accessToken) {
        [header setValue:accessToken forKey:@"X-FIVEMILES-USER-TOKEN"];
    }
    
    NSString *userId = [JNSession shareInstance].userId;
    if(userId) {
        [header setValue:userId forKey:@"X-FIVEMILES-USER-ID"];
    }
    
    [header setValue:[[UIDevice currentDevice] identifierForVendor]
              forKey:@"X-FIVEMILES-DEVICE-ID"];
    [header setValue:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
              forKey:@"X-FIVEMILES-DEVICE-IDFA"];
    [header setValuesForKeysWithDictionary:headerParams];
    
    NSString *preferredLanguages = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    [header setValue:preferredLanguages forKey:@"Accept-Language"];
    
    NSMutableString *userAgentString = [NSMutableString new];
    for (NSString *key in _userAgentConfig.allKeys) {
        if (userAgentString.length) {
            [userAgentString appendString:@","];
        }
        [userAgentString appendFormat:@"%@:%@", key, _userAgentConfig[key]];
    }
    [header setValue:userAgentString forKey:@"X-FIVEMILES-USER-AGENT"];
    
    return header;
}


#pragma mark - httpBody
- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                        binaryData:(NSArray *)dataList
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    for (NSDictionary *dataConfig in dataList) {
        NSString *filename  = [dataConfig valueForKey:@"filename"];
        NSData   *data      = [dataConfig valueForKey:@"data"];
        NSString *mimetype  = @"text/html";
        NSString *fieldName = [dataConfig valueForKey:@"fieldname"];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}
#pragma mark - 网络类型
- (NSString *)networkType {
    NSString *type = nil;
    
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            type = @"Null";
            break;
            
        case 1:
            type = @"2G";
            break;
            
        case 2:
            type = @"3G";
            break;
            
        case 3:
            type = @"4G";
            break;
            
        case 4:
            type = @"LTE";
            break;
            
        case 5:
            type = @"Wifi";
            break;
            
            
        default:
            break;
    }
    
    return type;
}
@end
