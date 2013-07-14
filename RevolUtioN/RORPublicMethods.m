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

static NSInteger userId = -1;

+ (NSInteger)getUserId{
    if (userId <0){
//        RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
//        NSManagedObjectContext *context = delegate.managedObjectContext;
//        //get user id
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
//        [fetchRequest setEntity:entity];
//        NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
//        for (NSManagedObject *info in fetchObject) {
//            NSNumber *num = [info valueForKey:@"userId"];
//            userId = [num integerValue];
//        }
        
        NSMutableDictionary *userDict = [RORPublicMethods getUserInfoPList];
        NSNumber *userIdNum = [userDict valueForKey:@"userId"];
        userId = [userIdNum integerValue];
    }
    return userId;
}

+ (void)resetUserId{
    userId = -1;
}

+ (NSMutableDictionary *)getUserInfoPList{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (userDict == nil)
        userDict = [[NSMutableDictionary alloc] init];

    return userDict;
}

+ (void)writeToUserInfoPList:(NSDictionary *) userDict{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userInfo.plist"];
    [userDict writeToFile:path atomically:YES];
}

+ (NSString*)getCityCodeJSon{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityCode" ofType:@"geojson"];
    return path;
}

+ (NSString*)getUserSettingsPList{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    return [docPath stringByAppendingPathComponent:@"userSettings.plist"];
}

+ (NSString *)hasLoggedIn{
    NSMutableDictionary *userDict = [RORPublicMethods getUserInfoPList];
    NSString *name = [userDict valueForKey:@"nickName"];
    
    if (!([name isEqual:@""] || name == nil))
        return name;
    else
        return nil;
}

+ (void)loginSync{
    [self syncFriends];
    [self syncRunningHistoryFromServer];
//    [self syncRunningHistoryToServer];
}

+ (void)synchronizeMissions {
//    NSInteger userId;
//    [self clearData];
    [self syncMissionPackagesFromServer];
    [self syncMissionsFromServer];
}

+ (void)syncFriends {
    NSError *error = nil;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    //sync user's friends
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/account/friends/%d",SERVICE_URL ,[self getUserId]]]];
    //    将请求的url数据放到NSData对象中
    NSHTTPURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//    NSLog(@"%@", [response description]);
    NSInteger statCode = [urlResponse statusCode];
    if (statCode == 200){
        NSArray *friendList = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@", [friendList description]);
        for (NSDictionary *friendDict in friendList){
            Friend *friendEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
            NSNumber *userIdNum = [friendDict valueForKey:@"userId"];
            NSNumber *friendIdNum = [friendDict valueForKey:@"friendId"];
            friendEntity.userId = userIdNum;
            friendEntity.friendId = friendIdNum;
            friendEntity.friendStatus = [friendDict valueForKey:@"friendStatus"];
//            friendEntity.addTime = [friendDict valueForKey:@"addTime"];
            User *userEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
            [userEntity initWithDictionary:friendDict];
            userEntity.userId = friendIdNum;
            
            User_Last_Location *lastLocEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Last_Location" inManagedObjectContext:context];
            lastLocEntity.userId = friendIdNum;
//            lastLocEntity.lastLocationPoint = [friendDict valueForKey:@"lastLocationPoint"];
//            lastLocEntity.lastLocationContent = [friendDict valueForKey:@"lastLocationContent"];
//            lastLocEntity.lastActiveTime = [friendDict valueForKey:@"lastActiveTime"];
        }
    } else {
        NSLog(@"sync with host error: can't get user's friends list. Status Code: %d", statCode);
    }
    
    if (![context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    [self saveLastUpdateTime:@"Friend"];
}

+ (void)saveLastUpdateTime: (NSString *) key{
    NSMutableDictionary *userDict = [RORPublicMethods getUserInfoPList];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formatDateString = [formate stringFromDate:[NSDate date]];
    [userDict setValue:formatDateString forKey:key];
    [RORPublicMethods writeToUserInfoPList:userDict];
}

+ (NSString *)getLastUpdateTime: (NSString *) key{
    NSMutableDictionary *userDict = [RORPublicMethods getUserInfoPList];
    return (NSString *)[userDict objectForKey:key];
}


+ (void)syncMissionsAndProducts{
    
    [self syncMissionPackagesFromServer];
    [self syncMissionsFromServer];
}

+ (void)syncMissionPackagesFromServer{
    NSError *error = nil;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSString *lastUpdateTime = [self getLastUpdateTime:@"Mission_Package"];
    NSURLRequest *request ;
    if (lastUpdateTime == nil || [lastUpdateTime isEqualToString:@""]) {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/missions/package",SERVICE_URL]]];
    } else {
        NSLog(@"Last <Mission Package> update time is:%@", lastUpdateTime);
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/missions/package?lastUpdateTime=%@",SERVICE_URL, lastUpdateTime]]];
    }

    //    将请求的url数据放到NSData对象中
    NSHTTPURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    //    NSLog(@"%@", [response description]);
    NSInteger statCode = [urlResponse statusCode];
    if (statCode == 200){
        NSArray *missionPackageList = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@", [missionPackageList description]);
        for (NSDictionary *missionPackageDict in missionPackageList){
            NSArray *subMissionList = [missionPackageDict valueForKey:@"missionPackageList"];
            for (id subMission in subMissionList){
                Mission_Package *missionPackageEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mission_Package" inManagedObjectContext:context];
                missionPackageEntity.missionPackageId = [missionPackageDict valueForKey:@"missionPackageId"];
                missionPackageEntity.missionPackageName = [missionPackageDict valueForKey:@"missionPackageName"];
                missionPackageEntity.missionPackageDescription = [missionPackageDict valueForKey:@"missionPackageDescription"];
                missionPackageEntity.missionId = [subMission valueForKey:@"missionId"];
                missionPackageEntity.missionTypeId = [subMission valueForKey:@"missionTypeId"];
                missionPackageEntity.sequence = [subMission valueForKey:@"sequence"];
            }
        }
        [self saveLastUpdateTime:@"Mission_Package"];
    } else {
        NSLog(@"sync with host error: can't get mission package list. Status Code: %d", statCode);
    }
    
    if (![context save:&error]) {
        NSLog(@"error %@",[error localizedDescription]);
    }    
}

+ (void)syncMissionsFromServer {
    NSError *error = nil;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSString *lastUpdateTime = [self getLastUpdateTime:@"Mission"];
    NSURLRequest *request ;
    if (lastUpdateTime == nil || [lastUpdateTime isEqualToString:@""]) {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/missions/mission",SERVICE_URL]]];
    } else {
        NSLog(@"Last <Mission> update time is:%@", lastUpdateTime);
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/missions/mission?lastUpdateTime=%@",SERVICE_URL, lastUpdateTime]]];
    }
    //    将请求的url数据放到NSData对象中
    NSHTTPURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    //    NSLog(@"%@", [response description]);
    NSInteger statCode = [urlResponse statusCode];
    if (statCode == 200){
        NSArray *missionList = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@", [missionList description]);
        for (NSDictionary *missionDict in missionList){
            Mission *missionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mission" inManagedObjectContext:context];
            [missionEntity initWithDictionary:missionDict];
            
            if (![[missionDict valueForKey:@"missionPlacePackages"] isKindOfClass:[NSNull class]]){
                NSArray *placeList = [missionDict valueForKey:@"missionPlacePackages"];
                for (NSDictionary *place in placeList){
                    Place_Package *placeEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Place_Package" inManagedObjectContext:context];
                    [placeEntity initWithDictionary:place];
                }
            }
        }
        [self saveLastUpdateTime:@"Mission"];

    } else {
        NSLog(@"sync with host error: can't get mission list. Status Code: %d", statCode);
    }
    
    if (![context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

+ (void)syncRunningHistory{

}

+ (void)syncRunningHistoryToServer{
    NSError *error = nil;
<<<<<<< HEAD
//    NSString *lastUpdateTime = [self getLastUpdateTime:@"User_Running_History"];

=======
    NSString *lastUpdateTime = [self getLastUpdateTime:@"User_Running_History"];
>>>>>>> 780d4fcd0eb0533322bf3e93679b6567627e13ca
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSMutableArray *dataList = [[NSMutableArray alloc]init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Running_History" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        if ([info valueForKey:@"userId"] == nil)
            [dataList addObject:info];
    }
    
<<<<<<< HEAD
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSLog(@"Start Create JSON!");
    NSString *dataStr = [writer stringWithObject:dataList];
    NSLog(@"%@",dataStr);
    NSData *dataData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    //        //=================================
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/running/history/%d",SERVICE_URL, [RORPublicMethods getUserId]]]];
    //    将请求的url数据放到NSData对象中
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: dataData];
    NSLog(@"==========request desp.==========\n%@",[request description]);
    NSHTTPURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    NSInteger statCode = [urlResponse statusCode];
=======
    NSString *requestUrl = [NSString stringWithFormat:RUNNING_HISTORY_URL, [RORPublicMethods getUserId]];
    RORHttpResponse *httpResponse = [RORHttpClientHandler postRequest:requestUrl withRequstBody:[RORUtils toJsonFormObject:dataList]];
>>>>>>> 780d4fcd0eb0533322bf3e93679b6567627e13ca
    
    if ([httpResponse responseStatus] == 200){
        for (User_Running_History *info in fetchObject) {
            NSMutableDictionary *userDict = [RORPublicMethods getUserInfoPList];
            info.userId = [userDict valueForKey:@"userId"];
        }
        [self saveLastUpdateTime:@"User_Running_History"];

    } else {
        NSLog(@"error: statCode = %@", [httpResponse errorMessage]);
    }
    
    if (![context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

+ (void)syncRunningHistoryFromServer {
    NSError *error = nil;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    //        //=================================
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/running/history/%d",SERVICE_URL, [RORPublicMethods getUserId]]]];
    //    将请求的url数据放到NSData对象中

    NSHTTPURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    NSInteger statCode = [urlResponse statusCode];
    
    if (statCode == 200){
        NSArray *responseList = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@", [responseList description]);
        for (NSDictionary *dictFromServer in responseList) {
            User_Running_History *runningHistoryEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Running_History" inManagedObjectContext:context];
            [runningHistoryEntity initByDictionary:dictFromServer];
        }
    } else {
        NSLog(@"error: statCode = %d", statCode);
    }
    if (![context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}


+ (void) deleteUserInfoFromDatabase: (NSNumber *) userId {
    NSError *error = nil;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    //init user basic info
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Attributes" inManagedObjectContext:context];
    //    NSInteger userId_int = [userId integerValue];
    [fetchRequest setEntity:entity];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        if ([[info valueForKey:@"userId"] isEqualToNumber:userId]) {
            [context deleteObject:info];
            break;
        }
    }
    entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    //    NSInteger userId_int = [userId integerValue];
    [fetchRequest setEntity:entity];
    fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        if ([[info valueForKey:@"userId"] isEqualToNumber:userId]) {
            [context deleteObject:info];
            break;
        }
    }
    [context save:&error];
}

+ (NSString *)transSecondToStandardFormat:(NSInteger) seconds {
    NSInteger min=0, hour=0;
    min = seconds / 60;
    seconds = seconds % 60;
    hour = min / 60;
    min = min % 60;
    return [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hour, min, seconds];
}

+ (NSNumber *)getCurrentRunHistoryId{
    User_Attributes *userAttr = nil;
    NSError *error = nil;
    
    NSMutableDictionary *userDict = [RORPublicMethods getUserInfoPList];
    NSNumber *userId = [userDict valueForKey:@"userId"];
    
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Attributes" inManagedObjectContext:context];
    //    NSInteger userId_int = [userId integerValue];
    [fetchRequest setEntity:entity];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        if ([[info valueForKey:@"userId"] isEqualToNumber:userId]) {
            userAttr = (User_Attributes *) info;
            break;
        }
    }
//    NSInteger runId = [userAttr.latestRunId integerValue];
//    NSInteger finalRunId = [userId integerValue] * 100000 + runId;
    
    return userAttr.latestRunId;
}

+ (void)newRunHistoryId{
    User_Attributes *userAttr = nil;
    NSError *error = nil;
    
    NSMutableDictionary *userDict = [RORPublicMethods getUserInfoPList];
    NSNumber *userId = [userDict valueForKey:@"userId"];
    
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Attributes" inManagedObjectContext:context];
    //    NSInteger userId_int = [userId integerValue];
    [fetchRequest setEntity:entity];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        if ([[info valueForKey:@"userId"] isEqualToNumber:userId]) {
            userAttr = (User_Attributes *) info;
            break;
        }
    }
    userAttr.latestRunId =[[NSNumber alloc] initWithInteger:1+[userAttr.latestRunId integerValue]];
    if (![context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

+ (void) loadUserInfoFromDict:(NSDictionary *) userInfoDic{
    User *user = nil;
    User_Attributes *userAttr = nil;
    NSError *error;
    //如果数据库里已经有这个人的数据，就先把原来的删了
//    [self deleteUserInfoFromDatabase:[userInfoDic valueForKey:@"userId"]];
    NSNumber *userId = [userInfoDic valueForKey:@"userId"];
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    //    NSInteger userId_int = [userId integerValue];
    [fetchRequest setEntity:entity];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        if ([[info valueForKey:@"userId"] isEqualToNumber:userId]) {
            user = (User *) info;
            break;
        }
    }

    entity = [NSEntityDescription entityForName:@"User_Attributes" inManagedObjectContext:context];
    //    NSInteger userId_int = [userId integerValue];
    [fetchRequest setEntity:entity];
    fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        if ([[info valueForKey:@"userId"] isEqualToNumber:userId]) {
            userAttr = (User_Attributes *) info;
            break;
        }
    }
    
    //init user basic info
    if (user == nil)
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    user.userEmail = [userInfoDic valueForKey:@"userEmail"];
    user.nickName = [userInfoDic valueForKey:@"nickName"];
    user.userId = [userInfoDic valueForKey:@"userId"];
    user.sex = [userInfoDic valueForKey:@"sex"];
    //init user attribute info
    if (userAttr == nil)
        userAttr = [NSEntityDescription insertNewObjectForEntityForName:@"User_Attributes" inManagedObjectContext:context];
    userAttr.userId = [userInfoDic valueForKey:@"userId"];
    userAttr.level = [userInfoDic valueForKey:@"level"];
    userAttr.crit = [userInfoDic valueForKey:@"crit"];
    userAttr.baseAcc = [userInfoDic valueForKey:@"baseAcc"];
    userAttr.experience = [userInfoDic valueForKey:@"experience"];
    userAttr.inertiaAcc = [userInfoDic valueForKey:@"inertiaAcc"];
    userAttr.luck = [userInfoDic valueForKey:@"luck"];
    userAttr.scores = [userInfoDic valueForKey:@"scores"];
//    userAttr.latestRunId = [userInfoDic valueForKey:@"latestRunId"];
    if (![context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

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
