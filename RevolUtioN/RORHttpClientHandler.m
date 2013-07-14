//
//  RORHttpClientHandler.m
//  RevolUtioN
//
//  Created by leon on 13-7-9.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORHttpClientHandler.h"
#import "RORUtils.h"

@implementation RORHttpClientHandler

+(RORHttpResponse *) postRequest:(NSString *)url withRequstBody:(NSString *)reqBody {
    NSLog(@"post request: %@ \r\n %@",url,reqBody);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //set http Method
    [request setHTTPMethod:@"POST"];
    //set http headers
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding" ];
    
    //todo: add key NSString *key=@"key";
    //[request addValue:key forHTTPHeaderField:@"X-CLIENT-KEY"]
    
    //set http request data
    NSData *regData = [reqBody dataUsingEncoding: NSUTF8StringEncoding];
    NSData *gzipRegData = [RORUtils gzipCompressData:regData];
    [request setHTTPBody:gzipRegData];
    
    RORHttpResponse *httpResponse = [self excuteRequest:request];
    return httpResponse;
}

+(RORHttpResponse *) putRequest:(NSString *)url withRequstBody:(NSString *)reqBody {
    NSLog(@"put request: %@ \r\n %@",url,reqBody);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //set http Method
    [request setHTTPMethod:@"PUT"];
    //set http headers
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding" ];
    //todo: add key NSString *key=@"key";
    //[request addValue:key forHTTPHeaderField:@"X-CLIENT-KEY"]
    
    //set http request data
    NSData *regData = [reqBody dataUsingEncoding: NSUTF8StringEncoding];
    NSData *gzipRegData = [RORUtils gzipCompressData:regData];
    [request setHTTPBody:gzipRegData];
    
    RORHttpResponse *httpResponse = [self excuteRequest:request];
    return httpResponse;
}

+(RORHttpResponse *) getRequest: (NSString *)url{
    NSLog(@"get request: %@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //set http Method
    [request setHTTPMethod:@"GET"];
    //set http headers
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //todo: add key NSString *key=@"key";
    //[request addValue:key forHTTPHeaderField:@"X-CLIENT-KEY"]
    
    RORHttpResponse *httpResponse = [self excuteRequest:request];
    return httpResponse;
}

+ (RORHttpResponse *) excuteRequest: (NSMutableURLRequest *)request{
    NSError *error = nil;
    NSHTTPURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    NSInteger statCode = [urlResponse statusCode];
    RORHttpResponse *httpResponse = [[RORHttpResponse alloc] init];
    [httpResponse setResponseStatus:statCode];
    [httpResponse setResponseData:response];
    if(statCode ==204){
        //change 204 status into 200.
        [httpResponse setResponseStatus:200];
    }
    else if(statCode == 409){
        NSDictionary *errorInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        [httpResponse setErrorCode:[errorInfoDic valueForKey:@"errorcode"]];
        [httpResponse setErrorMessage:[errorInfoDic valueForKey:@"errormessage"]];
    }
    else if(statCode == 500){
        [httpResponse setErrorCode:@"500"];
        [httpResponse setErrorMessage:@"UNKNOW_ERROR"];
    }
    return httpResponse;
}

@end

