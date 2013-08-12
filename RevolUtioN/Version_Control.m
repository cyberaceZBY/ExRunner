//
//  Version_Control.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Version_Control.h"
#import "RORDBCommon.h"

@implementation Version_Control

@synthesize platform;
@synthesize version;
@synthesize subVersion;
@synthesize desc;
@synthesize systemTime;

-(void)initWithDictionary:(NSDictionary *)dict{
    platform = [dict valueForKey:@"platform"];
    version = [dict valueForKey:@"version"];
    subVersion = [dict valueForKey:@"subVersion"];
    desc = [dict valueForKey:@"description"];
    systemTime = [RORDBCommon getDateFormatFromDict:[dict valueForKey:@"systemTime"]];
}

-(void)setPlatform:(id)obj{
    platform = [RORDBCommon getStringFromId:obj];
}

-(void)setVersion:(id)obj{
    version = [RORDBCommon getNumberFromId:obj];
}

-(void)setSubVersion:(id)obj{
    subVersion = [RORDBCommon getNumberFromId:obj];
}

-(void)setDesc:(id)obj{
    desc = [RORDBCommon getStringFromId:obj];
}

-(void)setSystemTime:(id)obj{
    systemTime = [RORDBCommon getDateFromId:obj];
}


@end
