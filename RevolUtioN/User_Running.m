//
//  User_Running.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "User_Running.h"
#import "RORDBCommon.h"

@implementation User_Running

@synthesize userId;
@synthesize missionId;
@synthesize missionTypeId;
@synthesize missionStatus;
@synthesize startTime;

-(void)setUserId:(id)obj{
    userId = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionId:(id)obj{
    missionId = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionTypeId:(id)obj{
    missionTypeId = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionStatus:(id)obj{
    missionStatus = [RORDBCommon getNumberFromId:obj];
}

-(void)setStartTime:(id)obj{
    startTime = [RORDBCommon getDateFromId:obj];
}


@end
