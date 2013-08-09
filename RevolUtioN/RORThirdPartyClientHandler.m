//
//  RORThirdPartyClientHandler.m
//  RevolUtioN
//
//  Created by leon on 13-8-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORThirdPartyClientHandler.h"

@implementation RORThirdPartyClientHandler

+(RORHttpResponse *)getWeatherInfo:(NSString *)citycode{
    NSString *url = [NSString stringWithFormat:WEATHER_URL, citycode];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getPM25Info:(NSString *)city withToken:(NSString *) token{
    NSString *url = [NSString stringWithFormat:PM25_URL, city, token];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}


@end
