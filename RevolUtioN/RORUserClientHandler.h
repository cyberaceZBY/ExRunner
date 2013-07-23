//
//  RORUserClientHandler.h
//  RevolUtioN
//
//  Created by leon on 13-7-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORConstant.h"
#import "RORUtils.h"
#import "RORHttpClientHandler.h"
#import "RORHttpResponse.h"

@interface RORUserClientHandler : NSObject

+(RORHttpResponse *)getUserInfoByUserNameAndPassword:(NSString *) userName withPassword:(NSString *) password;

+(RORHttpResponse *)createUserInfoByUserDic:(NSDictionary *) userInfo;

+(RORHttpResponse *)getUserFriends:(NSNumber *) userId withLastUpdateTime:(NSString *) lastUpdateTime;

@end
