//
//  User_Last_Location.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User_Last_Location : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * lastLocationContent;
@property (nonatomic, retain) NSString * lastLocationPoint;
@property (nonatomic, retain) NSDate * lastActiveTime;

@end
