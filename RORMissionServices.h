//
//  RORMissionServices.h
//  RevolUtioN
//
//  Created by leon on 13-7-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORAppDelegate.h"
#import "RORHttpResponse.h"
#import "RORMissionClientHandler.h"
#import "Mission.h"
#import "Mission_Package.h"
#import "Mission_Type.h"
#import "Place_Package.h"

@interface RORMissionServices : NSObject

+ (void)syncMissions;

+ (void)syncMissionPackages;

@end
