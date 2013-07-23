//
//  Friend.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friend : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * friendId;
@property (nonatomic, retain) NSNumber * friendStatus;
@property (nonatomic, retain) NSDate * addTime;
@property (nonatomic, retain) NSDate * updateTime;

-(void)initWithDictionary:(NSDictionary *)dict;

@end
