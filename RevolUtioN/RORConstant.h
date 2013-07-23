//
//  RORConstant.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef URLS
#define SERVICE_URL @"http://121.199.56.231:8080/usavich/service/api"
#define LOGIN_URL @"http://121.199.56.231:8080/usavich/service/api/account/%@/%@"
#define REGISTER_URL @"http://121.199.56.231:8080/usavich/service/api/account"
#define POST_RUNNING_HISTORY_URL @"http://121.199.56.231:8080/usavich/service/api/running/history/%@"
#define RUNNING_HISTORY_URL @"http://121.199.56.231:8080/usavich/service/api/running/history/%@?lastUpdateTime=%@"
#define POST_USER_RUNNING_URL @"http://121.199.56.231:8080/usavich/service/api/running/ongoing/%@"
#define USER_RUNNING_URL @"http://121.199.56.231:8080/usavich/service/api/running/ongoing/%@?lastUpdateTime=%@"
#define FRIEND_URL @"http://121.199.56.231:8080/usavich/service/api/account/friends/%@?lastUpdateTime=%@"
#define MISSION_PACKAGE_URL @"http://121.199.56.231:8080/usavich/service/api/missions/package?lastUpdateTime=%@"
#define MISSION_URL @"http://121.199.56.231:8080/usavich/service/api/missions/mission?lastUpdateTime=%@"
#endif

@interface RORConstant : NSObject

@end
