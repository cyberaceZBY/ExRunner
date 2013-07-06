//
//  Mission_Package.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Mission_Package.h"
#import "RORDBCommon.h"

@implementation Mission_Package

@synthesize missionId;
@synthesize missionPackageDescription;
@synthesize missionPackageId;
@synthesize missionPackageName;
@synthesize missionTypeId;
@synthesize sequence;
@synthesize lastUpdateTime;

-(void)setMissionId:(id)obj{
    missionId = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionPackageDescription:(id)obj{
    missionPackageDescription = [RORDBCommon getStringFromId:obj];
}

-(void)setMissionPackageId:(id)obj{
    missionPackageId = [RORDBCommon getNumberFromId:obj];
}

-(void)setMissionPackageName:(id)obj{
    missionPackageName = [RORDBCommon getStringFromId:obj];
}

-(void)setMissionTypeId:(id)obj{
    missionTypeId = [RORDBCommon getNumberFromId:obj];
}

-(void)setSequence:(id)obj{
    sequence = [RORDBCommon getNumberFromId:obj];
}

-(void)setLastUpdateTime:(id)obj{
    lastUpdateTime = [RORDBCommon getDateFromId:obj];
}

@end
