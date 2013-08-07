//
//  Mission.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Mission.h"
#import "RORDBCommon.h"


@implementation Mission

@synthesize cycleTime;
@synthesize experience;
@synthesize levelLimited;
@synthesize missionContent;
@synthesize missionDistance;
@synthesize missionFlag;
@synthesize missionFrom;
@synthesize missionId;
@synthesize missionName;
@synthesize missionPlacePackageId;
@synthesize missionSpeed;
@synthesize missionSteps;
@synthesize missionTime;
@synthesize missionTo;
@synthesize missionTypeId;
@synthesize scores;
@synthesize lastUpdateTime;
@synthesize challengeId;
@synthesize subMissionList;
@synthesize missionPackageId;
@synthesize sequence;

//array list for place package, challenge, submission
@synthesize missionPlacePackageList;
@synthesize challengeList;
@synthesize subMissionPackageList;

-(void)initWithDictionary:(NSDictionary *)dict{
    self.missionId = [dict valueForKey:@"missionId"];
    self.missionName = [dict valueForKey:@"missionName"];
    self.missionFrom = [dict valueForKey:@"missionFrom"];
    self.missionTypeId = [dict valueForKey:@"missionTypeId"];
    self.missionContent = [dict valueForKey:@"missionContent"];
    self.missionTo = [dict valueForKey:@"missionTo"];
    self.scores = [dict valueForKey:@"scores"];
    self.experience = [dict valueForKey:@"experience"];
    self.missionFlag = [dict valueForKey:@"missionFlag"];
    self.levelLimited = [dict valueForKey:@"levelLimited"];
    self.missionTime = [dict valueForKey:@"missionTime"];
    self.missionDistance = [dict valueForKey:@"missionDistance"];
    self.cycleTime = [dict valueForKey:@"cycleTime"];
    self.missionPlacePackageId = [dict valueForKey:@"missionPlacePackageId"];
    self.missionSteps = [dict valueForKey:@"missionSteps"];
    self.missionSpeed = [dict valueForKey:@"missionSpeed"];
    self.challengeId = [dict valueForKey:@"challengeId"];
    self.subMissionList = [dict valueForKey:@"subMissionList"];
    self.missionPackageId = [dict valueForKey:@"missionPackageId"];
    self.sequence = [dict valueForKey:@"sequence"];
}

-(void)setMissionId:(id)missId{
    missionId = [RORDBCommon getNumberFromId:missId];
}

-(void)setCycleTime:(id)cycletime{
    cycleTime = [RORDBCommon getNumberFromId:cycletime];
}

-(void)setExperience:(id)exp{
    experience = [RORDBCommon getNumberFromId:exp];
}

-(void)setLevelLimited:(id)ll{
    levelLimited = [RORDBCommon getNumberFromId:ll];
}

-(void)setMissionContent:(id)mc{
    missionContent = [RORDBCommon getStringFromId:mc];
}

-(void)setMissionDistance:(id)md{
    missionDistance = [RORDBCommon getNumberFromId:md];
}

-(void)setMissionFlag:(id)mf{
    missionFlag = [RORDBCommon getNumberFromId:mf];
}

-(void)setMissionFrom:(id)obj{
    missionFrom = [RORDBCommon getStringFromId:obj];
}

-(void)setMissionName:(id)obj{
    missionName = [RORDBCommon getStringFromId:obj];
}

-(void)setMissionPlacePackageId:(id)obj{
    missionPlacePackageId = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionSpeed:(id)obj{
    missionSpeed = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionSteps:(id)obj{
    missionSteps = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionTime:(id)obj{
    missionTime = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionTo:(id)obj{
    missionTo = [RORDBCommon getStringFromId:obj];
}

-(void)setMissionTypeId:(id)obj{
    missionTypeId = [RORDBCommon getNumberFromId:obj];
}

-(void)setScores:(id)obj{
    scores = [RORDBCommon getNumberFromId:obj];
}

-(void)setLastUpdateTime:(id)obj{
    lastUpdateTime = [RORDBCommon getDateFromId:obj];
}

-(void)setChallengeId:(id)obj{
    challengeId =[RORDBCommon getNumberFromId:obj];
}

-(void)setSubMissionList:(id)obj{
    subMissionList =[RORDBCommon getStringFromId:obj];
}

-(void)setMissionPackageId:(id)obj{
    missionPackageId =[RORDBCommon getNumberFromId:obj];
}

-(void)setSequence:(id)obj{
    sequence =[RORDBCommon getNumberFromId:obj];
}

@end
