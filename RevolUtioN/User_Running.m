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
@synthesize runUuid;
@synthesize missionId;
@synthesize missionTypeId;
@synthesize missionStatus;
@synthesize startTime;
@synthesize endTime;
@synthesize commitTime;

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:userId forKey:@"userId"];
    [tempoDict setValue:userId forKey:@"runUuid"];
    [tempoDict setValue:missionId forKey:@"missionId"];
    [tempoDict setValue:missionTypeId forKey:@"missionTypeId"];
    [tempoDict setValue:missionStatus forKey:@"missionStatus"];
    [tempoDict setValue:[RORDBCommon getStringFromId:startTime] forKey:@"startTime"];
    [tempoDict setValue:[RORDBCommon getStringFromId:startTime] forKey:@"endTime"];
    [tempoDict setValue:[RORDBCommon getStringFromId:commitTime] forKey:@"commitTime"];
    return tempoDict;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.userId = [dict valueForKey:@"userId"];
    self.runUuid = [dict valueForKey:@"runUuid"];
    self.missionId = [dict valueForKey:@"missionId"];
    self.missionTypeId = [dict valueForKey:@"missionTypeId"];
    self.missionStatus = [dict valueForKey:@"missionStatus"];
    self.startTime = [RORDBCommon getDateFromId:[dict valueForKey:@"startTime"]];
    self.endTime = [RORDBCommon getDateFromId:[dict valueForKey:@"endTime"]];
    self.commitTime = [RORDBCommon getDateFromId:[dict valueForKey:@"commitTime"]];
}


-(void)setUserId:(id)obj{
    userId = [RORDBCommon getNumberFromId:obj];
}

-(void)setRunUuid:(id)obj{
    runUuid = [RORDBCommon getStringFromId:obj];
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

-(void)setEndTime:(id)obj{
    endTime = [RORDBCommon getDateFromId:obj];
}

-(void)setCommitTime:(id)obj{
    commitTime = [RORDBCommon getDateFromId:obj];
}

@end
