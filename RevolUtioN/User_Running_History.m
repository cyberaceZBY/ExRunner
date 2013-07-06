//
//  User_Running_History.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "User_Running_History.h"
#import "RORDBCommon.h"

@implementation User_Running_History

@synthesize userId;
@synthesize missionId;
@synthesize missionTypeId;
@synthesize missionRoute;
@synthesize missionStartTime;
@synthesize missionEndTime;
@synthesize missionDate;
@synthesize spendCarlorie;
@synthesize duration;
@synthesize avgSpeed;
@synthesize distance;
@synthesize offerUsers;
@synthesize missionGrade;
@synthesize scores;
@synthesize experience;
@synthesize comment;
@synthesize synchronizeDate;

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:avgSpeed forKey:@"avgSpeed"];
    [tempoDict setValue:comment forKey:@"comment"];
    [tempoDict setValue:distance forKey:@"distance"];
    [tempoDict setValue:userId forKey:@"userId"];
    [tempoDict setValue:missionTypeId forKey:@"missionTypeId"];
    [tempoDict setValue:missionRoute forKey:@"missionRoute"];
    [tempoDict setValue:[RORDBCommon getStringFromId:missionStartTime] forKey:@"missionStartTime"];
    [tempoDict setValue:[RORDBCommon getStringFromId:missionEndTime] forKey:@"missionEndTime"];
    [tempoDict setValue:[RORDBCommon getStringFromId:missionDate] forKey:@"missionDate"];
    [tempoDict setValue:spendCarlorie forKey:@"spendCarlorie"];
    [tempoDict setValue:duration forKey:@"duration"];
    [tempoDict setValue:offerUsers forKey:@"offerUsers"];
    [tempoDict setValue:missionGrade forKey:@"missionGrade"];
    [tempoDict setValue:scores forKey:@"scores"];
    [tempoDict setValue:experience forKey:@"experience"];
    [tempoDict setValue:missionId forKey:@"missionId"];
    return tempoDict;
}

-(void)initByDictionary:(NSDictionary *)dict{
    self.avgSpeed = [dict valueForKey:@"avgSpeed"];
    self.comment = [dict valueForKey:@"comment"];
    self.distance = [dict valueForKey:@"distance"];
    self.userId = [dict valueForKey:@"userId"];
    self.missionTypeId = [dict valueForKey:@"missionTypeId"];
    self.missionRoute = [dict valueForKey:@"missionRoute"];
    self.missionStartTime = [RORDBCommon getDateFromId:[dict valueForKey:@"missionStartTime"]];
    self.missionEndTime = [RORDBCommon getDateFromId:[dict valueForKey:@"missionEndTime"]];
    self.missionDate = [RORDBCommon getDateFromId:[dict valueForKey:@"missionDate"]];
    self.spendCarlorie = [dict valueForKey:@"spendCarlorie"];
    self.duration = [dict valueForKey:@"duration"];
    self.offerUsers = [dict valueForKey:@"offerUsers"];
    self.missionGrade = [dict valueForKey:@"missionGrade"];
    self.scores = [dict valueForKey:@"scores"];
    self.experience = [dict valueForKey:@"experience"];
    self.missionId = [dict valueForKey:@"missionId"];
}

-(void)setUserId:(id)obj{
    userId = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionId:(id)obj{
    missionId = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionTypeId:(id)obj{
    missionTypeId = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionRoute:(id)obj{
    missionRoute = [RORDBCommon getStringFromId:obj];
}

-(void)setMissionStartTime:(id)obj{
    missionStartTime = [RORDBCommon getDateFromId:obj];
}

-(void)setMissionEndTime:(id)obj{
    missionEndTime = [RORDBCommon getDateFromId:obj];
}

-(void)setMissionDate:(id)obj{
    missionDate = [RORDBCommon getDateFromId:obj];
}

-(void)setSpendCarlorie:(id)obj{
    spendCarlorie = [RORDBCommon getNumberFromId:obj];
}

-(void)setDuration:(id)obj{
    duration = [RORDBCommon getNumberFromId:obj];
}

-(void)setAvgSpeed:(id)obj{
    avgSpeed = [RORDBCommon getNumberFromId:obj];
}

-(void)setDistance:(id)obj{
    distance = [RORDBCommon getNumberFromId:obj];
}

-(void)setOfferUsers:(id)obj{
    offerUsers = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionGrade:(id)obj{
    missionGrade = [RORDBCommon getNumberFromId:obj];
}

-(void)setScores:(id)obj{
    scores = [RORDBCommon getNumberFromId:obj];
}

-(void)setExperience:(id)obj{
    experience = [RORDBCommon getNumberFromId:obj];
}

-(void)setComment:(id)obj{
    comment = [RORDBCommon getStringFromId:obj];
}

-(void)setSynchronizeDate:(id)obj{
    synchronizeDate = [RORDBCommon getDateFromId:obj];
}

@end
