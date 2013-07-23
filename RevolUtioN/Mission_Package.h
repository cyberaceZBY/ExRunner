//
//  Mission_Package.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Mission_Package : NSManagedObject

@property (nonatomic, retain) NSNumber * missionId;
@property (nonatomic, retain) NSString * missionPackageDescription;
@property (nonatomic, retain) NSNumber * missionPackageId;
@property (nonatomic, retain) NSString * missionPackageName;
@property (nonatomic, retain) NSNumber * missionTypeId;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSDate * lastUpdateTime;

-(void)initWithDictionary:(NSDictionary *)dict;

-(void)initWithDictionary:(NSDictionary *)dict withSubDictionary:(NSDictionary *)subDict;

@end
