//
//  RORUserServices.h
//  RevolUtioN
//
//  Created by leon on 13-7-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Friend.h"
#import "User_Attributes.h"
#import "RORAppDelegate.h"
#import "RORHttpResponse.h"
#import "RORUserClientHandler.h"

@interface RORUserServices : NSObject

+ (void)syncUserInfo:(NSNumber *)userId withUserDic:(NSDictionary *) userInfoDic;

+ (void)syncFriends:(NSNumber *) userId;

+(void)clearUserData;

@end
