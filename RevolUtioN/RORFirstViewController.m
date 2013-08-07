//
//  RORFirstViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORFirstViewController.h"
#import "RORAppDelegate.h"
#import "RORSettings.h"
#import "Mission.h"
#import <UIKit/UIKit.h>
#import "RORPages.h"
#import "RORUtils.h"
#import "RORMissionServices.h"

@interface RORFirstViewController ()

@end

@implementation RORFirstViewController
@synthesize userInfoView;
@synthesize weatherSubView;
@synthesize weatherInfoButtonView;
@synthesize userButton;
@synthesize context;
@synthesize nonPlanView;

NSInteger expanded = 0;
BOOL isWeatherButtonClicked = false;
NSInteger centerLoc = -10000;
UITableViewCell *routeCheckedCell = nil;

- (void)viewDidLoad
{
    [super viewDidLoad];
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    context = delegate.managedObjectContext;

    userInfoView.frame = CGRectMake(0, -200, 320, 200);
    weatherSubView.frame = CGRectMake(2, -120, 100, 120);
    nonPlanView.frame = CGRectMake(0, 0, 320, 155);
    self.navigationItem.leftBarButtonItem = weatherInfoButtonView;
    //init topbar's gesture listeners
    UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [weatherSubView addGestureRecognizer:t];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [weatherSubView addGestureRecognizer:panGes];
    
    
    
    //应用初始设置
    NSString *userSettingDocPath = [RORUtils getUserSettingsPList];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:userSettingDocPath];
    if (data == nil) {
        NSString *userSettingPath = [[NSBundle mainBundle] pathForResource:@"DefaultSettings" ofType:@"plist"];
        data = [[NSDictionary alloc] initWithContentsOfFile:userSettingPath];
        [data writeToFile:userSettingDocPath atomically:YES];
    }
    //订阅
    [[RORSettings getInstance] addObserver:self forKeyPath:@"location" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    //=============加载天气信息=============
    [self loadWeatherInfo];
}

- (void)initPageData{
        
    //初始化用户名
    NSMutableDictionary *userDict = [RORUtils getUserInfoPList];
    
    if ([userDict valueForKey:@"userId"] == nil){
        [userButton setTitle:@"请登录" forState:UIControlStateNormal];
        [userButton removeTarget:self action:@selector(segueToInfo) forControlEvents:UIControlEventTouchUpInside];
        [userButton addTarget:self action:@selector(segueToLogin) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.userName = [userDict valueForKey:@"nickName"];
        self.userId = [userDict valueForKey:@"userId"];
        [userButton setTitle:self.userName forState:UIControlStateNormal];
        [userButton removeTarget:self action:@selector(segueToLogin) forControlEvents:UIControlEventTouchUpInside];
        [userButton addTarget:self action:@selector(segueToInfo) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initPageData];
}

- (void)segueToLogin{
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

-(void)segueToInfo{
    [self performSegueWithIdentifier:@"userInfoSegue"sender:self];
}

- (void)loadWeatherInfo{
    NSString *settingPath = [RORUtils getUserSettingsPList];
    if (settingPath != nil){ 
        NSMutableDictionary *settings = [RORSettings getInstance];
        NSMutableDictionary *location = [settings objectForKey:@"location"];
        NSString *citycode = [location valueForKey:@"code"];
        NSError *error;
        //    加载一个NSURL对象
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",citycode]]];
        //    将请求的url数据放到NSData对象中
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        if (response != nil){
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
            NSDictionary *weatherInfo = [weatherDic objectForKey:@"weatherinfo"];
            
            UILabel *label = (UILabel *)[weatherSubView viewWithTag:1];
            label.text = [weatherInfo objectForKey:@"temp1"];
            label = (UILabel *)[weatherSubView viewWithTag:2];
            label.text = [weatherInfo objectForKey:@"wind1"];
        }
        //空气质量API=========================
//        request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.pm25.in/api/querys/pm2_5.json?city=shanghai&token=5j1znBVAsnSf5xQyNQyq"]]];
//        //    将请求的url数据放到NSData对象中
//        response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//        weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//        NSLog(@"%@", [weatherDic description]);
        
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"location"]){
        [self loadWeatherInfo];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setSelection:)]){
        [destination setValue:self.userName forKey:@"userName"];
        [destination setValue:self.userId forKey:@"userId"];
    }
}

-(void) panAction:(UIPanGestureRecognizer*) recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        centerLoc = weatherSubView.center.y;
//        NSLog(@"began");
    }
    CGPoint translation = [recognizer translationInView:weatherSubView];
    [self weatherDragView:translation.y];

    CGContextRef gccontext = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:gccontext];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.6];
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        int trans = weatherSubView.center.y - centerLoc;
        if (trans>0 && expanded == 0 ){
            [self weatherInView];
            expanded = 1;
        } else if (trans<0 && expanded == 1 ){
            [self weatherPopView];
            expanded = 0;
        }
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];

    [recognizer setTranslation:CGPointZero inView:weatherSubView];
}

-(void) singleTap:(UITapGestureRecognizer*) tap {
    
    if (expanded) {
        [self weatherPopView];
        expanded = 0;
    }
    else {
        [self weatherInView];
        expanded = 1;
    }

//    NSLog(@"single tap: %f %f", p.x, p.y );
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [self setUserInfoView:nil];
    [self setUserInfoSubView:nil];
    [self setWeatherSubView:nil];
    [self setWeatherInfoButtonView:nil];
    [self setUserButton:nil];
    [self setNonPlanView:nil];
    [self setContext:nil];
    [self setUserName:nil];
    [self setUserId:nil];
    
    [super viewDidUnload];
}

- (void)weatherPopView{
    CGContextRef gccontext = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:gccontext];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    weatherSubView.frame = CGRectMake(2, -120, 100, 120);
    weatherInfoButtonView.tintColor = nil;
    expanded = 0;

    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

- (void)weatherDragView : (int)transition{
    UIView* localView = weatherSubView;
    static int TOP = -123;
    static int BOTTOM = 0;
    
    if (localView.frame.origin.y + transition>BOTTOM)
        localView.center = CGPointMake(localView.center.x,(localView.frame.size.height)/2); //61.5
    else if (localView.frame.origin.y + transition<TOP)
        localView.center = CGPointMake(localView.center.x,(localView.frame.size.height)/2+TOP);//25.5
    else localView.center = CGPointMake(localView.center.x,
                                           localView.center.y + transition);
}

- (void)weatherInView{
    CGContextRef gccontext = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:gccontext];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];

    weatherSubView.frame = CGRectMake(2, 0, 100, 120);
    weatherInfoButtonView.tintColor = [UIColor colorWithRed:0.25 green:0.4 blue:0.72 alpha:0.0];
    expanded = 1;

    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

- (IBAction)weatherInfoAction:(id)sender {
    if (weatherSubView.frame.origin.y < 0){
        [self weatherInView];
    } else {
        [self weatherPopView];
    }
}

- (IBAction)normalRunAction:(id)sender {
}

- (IBAction)challengeRunAction:(id)sender {
}

- (IBAction)userInfoMenu:(id)sender{
    CGContextRef gccontext = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:gccontext];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];

    if (userInfoView.frame.origin.y<-100)
        userInfoView.frame = CGRectMake(0, -100, 320, 200);
    else
        userInfoView.frame = CGRectMake(0, -200, 320, 200);

    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

@end
