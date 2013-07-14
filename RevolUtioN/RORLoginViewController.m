//
//  RORLoginViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORLoginViewController.h"
#import "User.h"
#import "User_Attributes.h"
#import "RORAppDelegate.h"
#import "RORPublicMethods.h"
#import "RORPages.h"
#import "RORConstant.h"
#import <SBJson/SBJson.h>

@interface RORLoginViewController ()

@end

@implementation RORLoginViewController
@synthesize usernameTextField;
@synthesize passwordTextField, nicknameTextField;
@synthesize switchButton, sexButton;
@synthesize context, delegate;

NSInteger tag = 0;

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
//    [self hasLoggedIn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
}

//提交用户名密码之后的操作
- (IBAction)loginAction:(id)sender {
    NSError *error = nil;
    if (![self isLegalInput]) return;
    if (switchButton.selectedSegmentIndex == 0){ //登录
        NSString *userName = usernameTextField.text;
        NSString *password = passwordTextField.text;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/account/%@/%@",SERVICE_URL ,userName, password]]];
        //    将请求的url数据放到NSData对象中
        NSHTTPURLResponse *urlResponse = nil;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
        //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSInteger statCode = [urlResponse statusCode];
        NSLog(@"%d", statCode);
        if (statCode == 200){
            NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
            //            NSDictionary *userInfo = [userInfoDic objectForKey:@"weatherinfo"];
            NSLog(@"%@", [userInfoDic description]);
            [self saveUserInfoFromDict:userInfoDic];
            [RORPublicMethods loginSync];
            //登录后刷新数据页面
//            [RORPages refreshPages];

            [self.navigationController popViewControllerAnimated:YES];

        } else if (statCode == 204) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
    } else { //注册
        NSDictionary *regDict = [[NSDictionary alloc]initWithObjectsAndKeys:usernameTextField.text, @"userEmail", passwordTextField.text, @"password", nicknameTextField.text, @"nickName", [sexButton selectedSegmentIndex]==0?@"男":@"女", @"sex", nil];
        SBJsonWriter *writer = [[SBJsonWriter alloc] init];
        NSLog(@"Start Create JSON!");
        NSString *regStr = [writer stringWithObject:regDict];
        NSLog(@"%@",regStr);
        
//        //=================================
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/account/",SERVICE_URL]]];
        //    将请求的url数据放到NSData对象中
        NSString *contentType = [NSString stringWithFormat:@"application/json"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setHTTPMethod:@"POST"];

        NSData *regData = [regStr dataUsingEncoding: NSUTF8StringEncoding];
        [request setHTTPBody:regData];
        NSHTTPURLResponse *urlResponse = nil;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
        NSInteger statCode = [urlResponse statusCode];

        if (statCode == 200){
            NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
            //            NSDictionary *userInfo = [userInfoDic objectForKey:@"weatherinfo"];
            NSLog(@"%@", [userInfoDic description]);
            [self saveUserInfoFromDict:userInfoDic];
            [RORPublicMethods loginSync];
//            [RORPages refreshPages];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册成功" message:@"恭喜你，注册成功！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];

            [self.navigationController popViewControllerAnimated:YES];

        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"注册失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
}

- (void) saveUserInfoFromDict:(NSDictionary *) userInfoDic{
    
    [RORPublicMethods loadUserInfoFromDict:userInfoDic];
    
    NSMutableDictionary *userDict = [RORPublicMethods getUserInfoPList];
    [userDict setValue:[userInfoDic valueForKey:@"userId"] forKey:@"userId"];
    [userDict setValue:[userInfoDic valueForKey:@"nickName"] forKey:@"nickName"];
    [userDict setValue:[NSDate date] forKey:@"loginDate"];
    [RORPublicMethods writeToUserInfoPList:userDict];
}

- (BOOL) isLegalInput {
    if (switchButton.selectedSegmentIndex == 0){
        if ([usernameTextField.text isEqualToString:@""] ||
            [passwordTextField.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入错误" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return NO;
        }
    } else {
        if ([usernameTextField.text isEqualToString:@""] ||
            [passwordTextField.text isEqualToString:@""] ||
            [nicknameTextField.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入错误" message:@"用户名,密码或昵称不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (IBAction)backgroundTap:(id)sender {
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [nicknameTextField resignFirstResponder];
}

- (IBAction)usernameDone:(id)sender {
}

- (IBAction)passwordDone:(id)sender {
    [passwordTextField resignFirstResponder];
}

- (IBAction)switchAction:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];

    nicknameTextField.alpha = [sender selectedSegmentIndex];
    sexButton.alpha = [sender selectedSegmentIndex];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

- (IBAction)visibilityOfPW:(id)sender {
    UISwitch *button = (UISwitch *)sender;
    passwordTextField.secureTextEntry = button.isOn;
    [passwordTextField resignFirstResponder];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES]; // for IOS 5+
}

- (void)viewDidUnload {
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setSwitchButton:nil];
    [self setNicknameTextField:nil];
    [self setSexButton:nil];
    [super viewDidUnload];
}


@end
