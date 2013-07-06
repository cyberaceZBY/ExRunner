//
//  Friend.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Friend.h"
#import "RORDBCommon.h"

@implementation Friend

@synthesize userId;
@synthesize friendId;
@synthesize friendStatus;
@synthesize addTime;

-(void)setUserId:(id)obj{
    userId = [RORDBCommon getNumberFromId:obj];
}

-(void)setFriendId:(id)obj{
    friendId = [RORDBCommon getNumberFromId:obj];
}

-(void)setFriendStatus:(id)obj{
    friendStatus = [RORDBCommon getNumberFromId:obj];
}

-(void)setAddTime:(id)obj{
    addTime = [RORDBCommon getDateFromId:obj];
}


@end
