//
//  RORDBCommon.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RORDBCommon : NSObject

+ (NSDate *)getDateFromId:(id)obj;
+ (NSDate *)getDateFormatFromDict:(NSString *) stringDate;
+ (NSString *)getStringFromId:(id)obj;
+ (NSNumber *)getNumberFromId:(id)obj;
+ (NSString *)getStringFromRoutePoints:(NSArray *)routePoints;
+ (NSArray *)getRoutePointsFromString:(NSString *)route_str;
@end
