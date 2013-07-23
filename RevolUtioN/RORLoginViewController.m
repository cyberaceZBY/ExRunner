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
#import "RORUtils.h"
#import "RORPages.h"
#import "RORConstant.h"
#import "RORUtils.h"
#import "RORUserClientHandler.h"
#import "RORHttpResponse.h"
#import "RORUserServices.h"

@interface RORLoginViewController ()

@end

@implementation RORLoginViewController
@synthesize usernameTextField;
@synthesize passwordTextField, nicknameTextField;
@synthesize switchButton, sexButton;
@synthesize context, delegate;

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

- (void)hasLoggedIn {
//    if ([RORUtils hasLoggedIn]!=nil){
//        //[alert show];
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
//        // 通过storyboard id拿到目标控制器的对象
//        UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"RORMainViewController"];
//        
//        [self.navigationController pushViewController:viewController animated:NO];
//    }
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
        NSString *password = [RORUtils md5:passwordTextField.text];
        RORHttpResponse *httpResponse = [RORUserClientHandler getUserInfoByUserNameAndPassword:userName withPassword:password];
        
        if ([httpResponse responseStatus] == 200){
            NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            [self firstLoginSync:userInfoDic];
            //[RORUtils loginSync];
        } else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
    } else { //注册
        NSDictionary *regDict = [[NSDictionary alloc]initWithObjectsAndKeys:usernameTextField.text, @"userEmail",[RORUtils md5:passwordTextField.text], @"password", nicknameTextField.text, @"nickName", [sexButton selectedSegmentIndex]==0?@"男":@"女", @"sex", nil];
        
        RORHttpResponse *httpResponse = [RORUserClientHandler createUserInfoByUserDic:regDict];
        
        if ([httpResponse responseStatus] == 200){
            NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            [self firstLoginSync:userInfoDic];
            //[RORUtils loginSync];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册成功" message:@"恭喜你，注册成功！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"用户名已存在" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    passwordTextField.text = @"";
    nicknameTextField.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) firstLoginSync:(NSDictionary *) userInfoDic{
    //init local DB.
    NSNumber *userId = [userInfoDic valueForKey:@"userId"];
    [RORUserServices syncUserInfo:userId withUserDic:userInfoDic];
    //init plist
    NSMutableDictionary *userDict = [RORUtils getUserInfoPList];
    [userDict setValue:[userInfoDic valueForKey:@"userId"] forKey:@"userId"];
    [userDict setValue:[userInfoDic valueForKey:@"nickName"] forKey:@"nickName"];
    [userDict setValue:[NSDate date] forKey:@"loginDate"];
    [RORUtils writeToUserInfoPList:userDict];
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
