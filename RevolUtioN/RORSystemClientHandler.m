//
//  RORSystemClientHandler.m
//  RevolUtioN
//
//  Created by leon on 13-8-10.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSystemClientHandler.h"

@implementation RORSystemClientHandler

+(RORHttpResponse *)getVersionInfo:(NSString *) platform{
    NSString *url = [NSString stringWithFormat:VERSION_URL ,platform];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}


@end
