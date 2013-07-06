//
//  Place_Package.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Place_Package.h"
#import "RORDBCommon.h"

@implementation Place_Package

@synthesize packageId;
@synthesize placeDesc;
@synthesize placeName;
@synthesize placePoint;
@synthesize sequence;

-(void)initWithDictionary:(NSDictionary *)dict{
    self.packageId = [dict valueForKey:@"packageId"];
    self.placeName = [dict valueForKey:@"placeName"];
    self.placePoint = [dict valueForKey:@"placePoint"];
    self.sequence = [dict valueForKey:@"sequence"];
}

-(void)setPackageId:(id)obj{
    packageId = [RORDBCommon getNumberFromId:obj];
}

-(void)setPlaceDesc:(id)obj{
    placeDesc = [RORDBCommon getStringFromId:obj];
}

-(void)setPlaceName:(id)obj{
    placeName = [RORDBCommon getStringFromId:obj];
}

-(void)setPlacePoint:(id)obj{
    placePoint = [RORDBCommon getStringFromId:obj];
}

-(void)setSequence:(id)obj{
    sequence = [RORDBCommon getNumberFromId:obj];
}

@end
