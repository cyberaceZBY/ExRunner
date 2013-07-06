//
//  Communication.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Communication : NSManagedObject

@property (nonatomic, retain) NSNumber * communicationId;
@property (nonatomic, retain) NSNumber * fromUserId;
@property (nonatomic, retain) NSNumber * toUserId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * time;

@end
