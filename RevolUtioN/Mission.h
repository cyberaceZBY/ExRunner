//
//  Mission.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Mission : NSManagedObject

@property (nonatomic, retain) NSNumber * cycleTime;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSNumber * levelLimited;
@property (nonatomic, retain) NSString * missionContent;
@property (nonatomic, retain) NSNumber * missionDistance;
@property (nonatomic, retain) NSNumber * missionFlag;
@property (nonatomic, retain) NSString * missionFrom;
@property (nonatomic, retain) NSNumber * missionId;
@property (nonatomic, retain) NSString * missionName;
@property (nonatomic, retain) NSNumber * missionPlacePackageId;
@property (nonatomic, retain) NSNumber * missionSpeed;
@property (nonatomic, retain) NSNumber * missionSteps;
@property (nonatomic, retain) NSNumber * missionTime;
@property (nonatomic, retain) NSString * missionTo;
@property (nonatomic, retain) NSNumber * missionTypeId;
@property (nonatomic, retain) NSNumber * scores;
@property (nonatomic, retain) NSDate * lastUpdateTime;

-(void)initWithDictionary:(NSDictionary *)dict;
@end
