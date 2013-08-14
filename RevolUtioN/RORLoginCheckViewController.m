//
//  RORLoginCheckViewController.m
//  RevolUtioN
//
//  Created by leon on 13-8-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORLoginCheckViewController.h"

@interface RORLoginCheckViewController ()

@end

@implementation RORLoginCheckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sinaWeiboLogin:(id)sender {
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [authOptions setPowerByHidden:true];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"Cyberace_赛跑乐"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    nil]];
    
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   [self loginFromSinaWeibo:userInfo];
                               }
                               else
                               {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                       message:error.errorDescription
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"知道了"
                                                                             otherButtonTitles: nil];
                                   [alertView show];
                               }
                           }];
    
}

- (void)viewDidUnload {
    [self setBtnSinaWeibo:nil];
    [super viewDidUnload];
}

- (void)loginFromSinaWeibo:(id<ISSUserInfo>)userInfo{
    
    NSString *userName = nil;
    NSString *password = [RORUtils md5:@"sinaweibo"];
    NSString *nickName = nil;
    NSString *sex = nil;
    NSArray *keys = [[userInfo sourceData] allKeys];
    for (int i = 0; i < [keys count]; i++)
    {
        NSString *keyName = [keys objectAtIndex:i];
        id value = [[userInfo sourceData] objectForKey:keyName];
        if (![value isKindOfClass:[NSString class]])
        {
            if ([value respondsToSelector:@selector(stringValue)])
            {
                value = [value stringValue];
            }
            else
            {
                value = @"";
            }
        }
        
        if([keyName isEqualToString:@"idstr"])
        {
            userName = value;
        }
        else if([keyName isEqualToString:@"screen_name"])
        {
            nickName = value;
        }
        else if([keyName isEqualToString:@"gender"])
        {
            if([(NSString*)value isEqual: @"f"]){
                sex = @"女";
            }
            else{
                sex = @"男";
            }
        }
    }
    
    User *user = [RORUserServices syncUserInfoByLogin:userName withUserPasswordL:password];
    
    if (user == nil){
        NSDictionary *regDict = [[NSDictionary alloc]initWithObjectsAndKeys:userName, @"userEmail",password, @"password", nickName, @"nickName", sex, @"sex", nil];
        [RORUserServices registerUser:regDict];
    }
}

@end
