//
//  RORPublicMethods.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RORPublicMethods : NSObject
+ (NSInteger)getUserId;
+ (NSMutableDictionary *)getUserInfoPList;
+ (void)writeToUserInfoPList:(NSDictionary *) userDict;
+ (NSString*)getCityCodeJSon;
+ (NSString*)getUserSettingsPList;
+ (void)synchronizeMissions;
+ (void)loginSync;
+ (void)syncRunningHistoryToServer;
+ (void) loadUserInfoFromDict:(NSDictionary *) userInfoDic;
+ (NSString *)transSecondToStandardFormat:(NSInteger) second;
+ (NSNumber *)getCurrentRunHistoryId;
+ (void)newRunHistoryId;
+ (NSString *)hasLoggedIn;
+ (void)syncMissionsAndProducts;
+ (void)resetUserId;
+ (void)clearData;
+ (void)clearUser;
@end

