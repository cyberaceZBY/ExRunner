//
//  Mission_Challenge.m
//  RevolUtioN
//
//  Created by leon on 13-8-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Mission_Challenge.h"
#import "RORDBCommon.h"


@implementation Mission_Challenge

@synthesize challengeId;
@synthesize grade;
@synthesize time;
@synthesize distance;
@synthesize sequence;
@synthesize note;

-(void)initWithDictionary:(NSDictionary *)dict{
    self.challengeId = [dict valueForKey:@"challengeId"];
    self.grade = [dict valueForKey:@"grade"];
    self.time = [dict valueForKey:@"time"];
    self.distance = [dict valueForKey:@"distance"];
    self.sequence = [dict valueForKey:@"sequence"];
    self.note = [dict valueForKey:@"note"];
}

-(void)setChallengeId:(id)obj{
    challengeId =[RORDBCommon getNumberFromId:obj];
}

-(void)setGrade:(id)obj{
    grade =[RORDBCommon getStringFromId:obj];
}

-(void)setTime:(id)obj{
    time =[RORDBCommon getNumberFromId:obj];
}

-(void)setDistance:(id)obj{
    distance =[RORDBCommon getNumberFromId:obj];
}

-(void)setSequence:(id)obj{
    sequence =[RORDBCommon getNumberFromId:obj];
}

-(void)setNote:(id)obj{
    note =[RORDBCommon getStringFromId:obj];
}

@end
