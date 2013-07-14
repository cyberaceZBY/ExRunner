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

@interface RORUtils : NSObject

+ (NSString *)md5:(NSString *)str;

+ (NSData *)gzipCompressData:(NSData *)uncompressedData;

+ (NSString *)toJsonFormObject:(NSObject *)object;

@end
