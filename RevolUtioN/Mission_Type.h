//
//  Mission_Type.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Mission_Type : NSManagedObject

@property (nonatomic, retain) NSNumber * missionTypeId;
@property (nonatomic, retain) NSString * missionName;

@end
