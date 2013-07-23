//
//  RORUtils.h
//  RevolUtioN
//
//  Created by leon on 13-7-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zlib.h" 
#import <SBJson/SBJson.h>
#import "RORAppDelegate.h"

@interface RORUtils : NSObject

+ (NSNumber *)getUserId;

+ (NSString *)transSecondToStandardFormat:(NSInteger) seconds;

+ (NSDate *)getSystemTime;

+ (NSString *)md5:(NSString *)str;

+ (NSData *)gzipCompressData:(NSData *)uncompressedData;

+ (NSString *)toJsonFormObject:(NSObject *)object;

+ (NSMutableDictionary *)getUserInfoPList;

+ (NSString*)getUserSettingsPList;

+ (void)writeToUserInfoPList:(NSDictionary *) userDict;

+ (void)saveLastUpdateTime: (NSString *) key;

+ (NSString *)getLastUpdateTime: (NSString *) key;

+(NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query;

+ (void)clearTableData:(NSArray *) tableArray;

+ (NSString*)getCityCodeJSon;

@end
