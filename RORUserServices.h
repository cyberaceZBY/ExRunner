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

+ (User *)fetchUser:(NSNumber *) userId;

+(User *)registerUser:(NSDictionary *)registerDic;

+(User *)syncUserInfoById:(NSNumber *)userId;

+(User *)syncUserInfoByLogin:(NSString *)userName withUserPasswordL:(NSString *) password;

+(void)syncFriends:(NSNumber *) userId;

+(void)clearUserData;

@end
