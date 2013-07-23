//
//  RORPublicMethods.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORPublicMethods.h"
#import "RORPages.h"
#import "RORConstant.h"
#import "RORAppDelegate.h"
#import "RORFirstViewController.h"
#import "User.h"
#import "User_Attributes.h"
#import "Friend.h"
#import "Running_Invite.h"
#import "User_Running.h"
#import "User_Running_History.h"
#import "User_Products_History.h"
#import "User_Last_Location.h"
#import "Mission_Package.h"
#import "Mission.h"
#import "Place_Package.h"
#import <SBJson/SBJson.h>
#import "RORDBCommon.h"
#import "RORHttpClientHandler.h"
#import "RORHttpResponse.h"
#import "RORUtils.h"


@implementation RORPublicMethods

+ (void)clearData{
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        [context deleteObject:info];
    }
    
    entity = [NSEntityDescription entityForName:@"User_Attributes" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        [context deleteObject:info];
    }
    
    entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        [context deleteObject:info];
    }
    
    entity = [NSEntityDescription entityForName:@"User_Last_Location" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        [context deleteObject:info];
    }
    
//    entity = [NSEntityDescription entityForName:@"Mission" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    fetchObject = [context executeFetchRequest:fetchRequest error:&error];
//    for (NSManagedObject *info in fetchObject) {
//        [context deleteObject:info];
//    }
//    
//    entity = [NSEntityDescription entityForName:@"Mission_Package" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    fetchObject = [context executeFetchRequest:fetchRequest error:&error];
//    for (NSManagedObject *info in fetchObject) {
//        [context deleteObject:info];
//    }
    
    entity = [NSEntityDescription entityForName:@"Place_Package" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        [context deleteObject:info];
    }
    
    entity = [NSEntityDescription entityForName:@"User_Running_History" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        [context deleteObject:info];
    }
    
    //保存修改
    [context save:&error];
}

+ (void)clearUser{
    //删除登录用户信息
    NSMutableDictionary *userDict = [RORPublicMethods getUserInfoPList];
    [userDict setValue:nil forKey:@"userId"];
    [userDict setValue:nil forKey:@"nickName"];
    [RORPublicMethods writeToUserInfoPList:userDict];
    [RORPublicMethods resetUserId];
}
@end
