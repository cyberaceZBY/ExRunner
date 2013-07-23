//
//  Products.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Products : NSManagedObject

@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSString * productDesc;
@property (nonatomic, retain) NSNumber * scores;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSNumber * triggerType;
@property (nonatomic, retain) NSNumber * levelLimit;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * discount;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * baseAcc;
@property (nonatomic, retain) NSNumber * inertiaAcc;
@property (nonatomic, retain) NSNumber * crit;
@property (nonatomic, retain) NSNumber * luck;
@property (nonatomic, retain) NSNumber * endurance;
@property (nonatomic, retain) NSNumber * spirit;
@property (nonatomic, retain) NSNumber * rapidly;

@end
