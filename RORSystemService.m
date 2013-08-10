//
//  RORSystemService.m
//  RevolUtioN
//
//  Created by leon on 13-8-10.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSystemService.h"

@implementation RORSystemService

+ (Version_Control *)fetchVersionInfo:(NSString *) platform{
    
    NSString *table=@"Version_Control";
    NSString *query = @"platform = %@";
    NSArray *params = [NSArray arrayWithObjects:platform, nil];
    NSArray *fetchObject = [RORUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return  (Version_Control *) [fetchObject objectAtIndex:0];
}

+ (void) saveSystimeTime:(NSString *)systemTime{
    NSMutableDictionary *userDict = [RORUtils getUserInfoPList];
    [userDict setValue:systemTime forKey:@"systemTime"];
    [RORUtils writeToUserInfoPList:userDict];
}

+(void)syncVersion:(NSString *)platform{
    NSError *error = nil;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    RORHttpResponse *httpResponse =[RORSystemClientHandler getVersionInfo:platform];
    
    if ([httpResponse responseStatus] == 200){
        NSDictionary *versionInfo = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        Version_Control *versionEntity = [self fetchVersionInfo:platform];
        if(versionEntity == nil)
            versionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Version_Control" inManagedObjectContext:context];
        [versionEntity initWithDictionary:versionInfo];
        
        if (![context save:&error]) {
            NSLog(@"%@",[error localizedDescription]);
        }
        
        [self saveSystimeTime:(NSString *)versionEntity.systemTime];
    } else {
        NSLog(@"sync with host error: can't get version info. Status Code: %d", [httpResponse responseStatus]);
    }
}

@end
