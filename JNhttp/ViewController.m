//
//  ViewController.m
//  JNhttp
//
//  Created by qianjn on 16/7/11.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "ViewController.h"
#import "NSData+Json.h"
#import "JNHttpRequest.h"
#import "JNHttpService.h"
#import "JNHttpConfig.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     //Do any additional setup after loading the view, typically from a nib.
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    //也可以设置httpheader, head还是习惯加在request里面
//    //    sessionConfig.HTTPAdditionalHeaders = @{@"Accept": @"application/json",
//    //                                            @"Accept-Language": @"en",
//    //                                            @"Authorization": authString,
//    //                                            @"User-Agent": userAgentString};
//    sessionConfig.HTTPMaximumConnectionsPerHost = 8; //连接到特定主机的数量
//    sessionConfig.timeoutIntervalForRequest = 30; //超时时间
//    //sessionConfig.allowsCellularAccess = YES;  //允许蜂窝访问；
//    sessionConfig.discretionary = YES;  //自行决定，建议在后台的时候自行决定
//    sessionConfig.sessionSendsLaunchEvents = NO; //一个新的属性，该属性指定该会话是否应该从后台启动
//    
//     NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
//    
//    
////
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.douban.com/j/app/radio/channels"]];
//    request.HTTPMethod = @"GET";
//
//   
//    
//    
//    
////
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        id result = [data jsonMObject:error];
//         NSLog(@"--%@", result);
//    }];
//    [task resume];
    

    [JNHttpRequest getWithSuffix:@"sdf"
                      parameters:nil
                        callBack:^(id  _Nullable result, NSError * _Nullable error, NSString * _Nullable errorMessage) {
       
        NSLog(@"%@", result);
        
    }];

}

@end
