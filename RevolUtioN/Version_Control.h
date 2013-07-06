//
//  Version_Control.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Version_Control : NSManagedObject

@property (nonatomic, retain) NSNumber * platform;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSNumber * subVersion;

@end
