//
//  NSURL+Parser.h
//  TestPageNavi
//
//  Created by Ryou Zhang on 6/19/13.
//  Copyright (c) 2013 Ryou Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Utility)
+(NSString *)urlEncodedString:(NSString *)sourceText;
+(NSString *)urlDecodingString:(NSString *)sourceText;

+(NSMutableDictionary *)parserQueryText:(NSString *)queryText;
+(NSString *)generateQueryText:(NSDictionary *)params;

@end
