//
//  User.h
//  RevolUtioN
//
//  Created by leon on 13-7-23.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User_Attributes.h"


@interface User_Base : NSManagedObject

@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * userEmail;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) User_Attributes * attributes;

//init user_base
+(User_Base *)init;

-(NSMutableDictionary *)transToDictionary;
-(void)initWithDictionary:(NSDictionary *)dict;

@end
