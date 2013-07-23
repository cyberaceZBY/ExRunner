//
//  RORMissionServices.m
//  RevolUtioN
//
//  Created by leon on 13-7-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMissionServices.h"


@implementation RORMissionServices


+(Mission_Package *)fetchMissionPackage:(NSNumber *) missionPackageId withMissionId:(NSNumber *) missionId{
    
    NSString *table=@"Mission_Package";
    NSString *query = @"missionPackageId = %@ and missionId = %@";
    NSArray *params = [NSArray arrayWithObjects:missionPackageId, missionId, nil];
    NSArray *fetchObject = [RORUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return   (Mission_Package *) [fetchObject objectAtIndex:0];
}

+(Mission *)fetchMission:(NSNumber *) missionId{
    NSString *table=@"Mission";
    NSString *query = @"missionId = %@";
    NSArray *params = [NSArray arrayWithObjects:missionId, nil];
    NSArray *fetchObject = [RORUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return   (Mission *) [fetchObject objectAtIndex:0];
}

+(void) deletePlacePackage:(NSNumber *) placePackageId{
    NSError *error;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mission" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSArray *arrayFilter = [NSArray arrayWithObjects:placePackageId, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"missionId = %@" argumentArray:arrayFilter];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return;
    }
    for (NSManagedObject *objectToDelete in fetchObject) {
        [context deleteObject:objectToDelete];
    }
    
    if (![context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

+ (void)syncMissionPackages{
    NSError *error = nil;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSString *lastUpdateTime = [RORUtils getLastUpdateTime:@"MissionPackageUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORMissionClientHandler getMissionPackage:lastUpdateTime];
    
    if ([httpResponse responseStatus] == 200){
        NSArray *missionPackageList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *missionPackageDict in missionPackageList){
            NSArray *subMissionList = [missionPackageDict valueForKey:@"missionPackageList"];
            NSNumber *missionPackageId = [missionPackageDict valueForKey:@"missionPackageId"];
            for (id subMissionDict in subMissionList){
                NSNumber *missionId = [subMissionDict valueForKey:@"missionId"];
                Mission_Package *missionPackageEntity = [self fetchMissionPackage:missionPackageId withMissionId:missionId];
                if(missionPackageEntity == nil)
                    missionPackageEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mission_Package" inManagedObjectContext:context];
                [missionPackageEntity initWithDictionary:missionPackageDict withSubDictionary:subMissionDict];
            }
        }
        if (![context save:&error]) {
            NSLog(@"error %@",[error localizedDescription]);
        }
        [RORUtils saveLastUpdateTime:@"MissionPackageUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get mission package list. Status Code: %d", [httpResponse responseStatus]);
    }
}

+ (void)syncMissions{
    NSError *error = nil;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSString *lastUpdateTime = [RORUtils getLastUpdateTime:@"MissionUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORMissionClientHandler getMissions:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *missionList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *missionDict in missionList){
            NSNumber *missionId = [missionDict valueForKey:@"missionId"];
            Mission *missionEntity = [self fetchMission:missionId];
            if(missionEntity == nil)
                missionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mission" inManagedObjectContext:context];
            [missionEntity initWithDictionary:missionDict];
            
            if (![[missionDict valueForKey:@"missionPlacePackages"] isKindOfClass:[NSNull class]]){
                NSArray *placeList = [missionDict valueForKey:@"missionPlacePackages"];
                for (NSDictionary *place in placeList){
                    NSNumber *placePackageId = [place valueForKey:@"packageId"];
                    [self deletePlacePackage:placePackageId];
                    Place_Package *placeEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Place_Package" inManagedObjectContext:context];
                    [placeEntity initWithDictionary:place];
                }
            }
        }
        if (![context save:&error]) {
            NSLog(@"%@",[error localizedDescription]);
        }
        
        [RORUtils saveLastUpdateTime:@"MissionUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get mission list. Status Code: %d", [httpResponse responseStatus]);
    }
}

@end
