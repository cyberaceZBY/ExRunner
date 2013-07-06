//
//  User_Attributes.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User_Attributes : NSManagedObject

@property (nonatomic, retain) NSNumber * baseAcc;
@property (nonatomic, retain) NSNumber * crit;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSNumber * inertiaAcc;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * luck;
@property (nonatomic, retain) NSNumber * scores;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * latestRunId;

@end
