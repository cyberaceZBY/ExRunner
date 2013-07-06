//
//  User_Attributes.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "User_Attributes.h"
#import "RORDBCommon.h"

@implementation User_Attributes

@synthesize baseAcc;
@synthesize crit;
@synthesize experience;
@synthesize inertiaAcc;
@synthesize level;
@synthesize luck;
@synthesize scores;
@synthesize userId;
@synthesize latestRunId;

-(void)setBaseAcc:(id)obj{
    baseAcc = [RORDBCommon getNumberFromId:obj];
}

-(void)setCrit:(id)obj{
    crit = [RORDBCommon getNumberFromId:obj];
}

-(void)setExperience:(id)obj{
    experience = [RORDBCommon getNumberFromId:obj];
}

-(void)setInertiaAcc:(id)obj{
    inertiaAcc = [RORDBCommon getNumberFromId:obj];
}

-(void)setLevel:(id)obj{
    level = [RORDBCommon getNumberFromId:obj];
}

-(void)setLuck:(id)obj{
    luck = [RORDBCommon getNumberFromId:obj];
}

-(void)setScores:(id)obj{
    scores = [RORDBCommon getNumberFromId:obj];
}

-(void)setUserId:(id)obj{
    userId = [RORDBCommon getNumberFromId:obj];
}

-(void)latestRunId:(id)obj{
    latestRunId = [RORDBCommon getNumberFromId:obj];
}

@end
