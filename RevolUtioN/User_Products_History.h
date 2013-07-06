//
//  User_Products_History.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User_Products_History : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * productsId;
@property (nonatomic, retain) NSNumber * scores;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSDate * buyTime;

@end
