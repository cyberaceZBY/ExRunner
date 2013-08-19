//
//  User.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "User_Base.h"
#import "RORDBCommon.h"
#import "RORAppDelegate.h"

@implementation User_Base

@synthesize nickName;
@synthesize password;
@synthesize userEmail;
@synthesize userId;
@synthesize sex;
@synthesize uuid;
@synthesize attributes;

+ (User_Base *)init{
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    User_Base *user = [NSEntityDescription insertNewObjectForEntityForName:@"User_Base" inManagedObjectContext:context];
    return user;
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:userId forKey:@"userId"];
    [tempoDict setValue:nickName forKey:@"nickName"];
    [tempoDict setValue:password forKey:@"password"];
    [tempoDict setValue:userEmail forKey:@"userEmail"];
    [tempoDict setValue:sex forKey:@"sex"];
    [tempoDict setValue:uuid forKey:@"uuid"];
    return tempoDict;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    userId = [dict valueForKey:@"userId"];
    nickName = [dict valueForKey:@"nickName"];
    userEmail = [dict valueForKey:@"userEmail"];
    sex = [dict valueForKey:@"sex"];
    uuid =[dict valueForKey:@"uuid"];
}

-(void)setNickName:(id)obj{
    nickName = [RORDBCommon getStringFromId:obj];
}

-(void)setPassword:(id)obj{
    password = [RORDBCommon getStringFromId:obj];
}

-(void)setUserEmail:(id)obj{
    userEmail = [RORDBCommon getStringFromId:obj];
}

-(void)setUserId:(id)obj{
    userId = [RORDBCommon getNumberFromId:obj];
}

-(void)setSex:(id)obj{
    sex = [RORDBCommon getStringFromId:obj];
}

-(void)setUuid:(id)obj{
    uuid = [RORDBCommon getStringFromId:obj];
}
@end
