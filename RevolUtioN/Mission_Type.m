//
//  Mission_Type.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Mission_Type.h"
#import "RORDBCommon.h"

@implementation Mission_Type

@synthesize missionTypeId;
@synthesize missionName;

-(void)setMissionTypeId:(id)obj{
    missionTypeId = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionName:(id)obj{
    missionName = [RORDBCommon getStringFromId:obj];
}

@end
