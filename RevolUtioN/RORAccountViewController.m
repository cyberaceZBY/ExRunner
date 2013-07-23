//
//  RORAccountViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-26.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORAccountViewController.h"
#import "RORPages.h"
#import "RORUtils.h"

@interface RORAccountViewController ()

@end

@implementation RORAccountViewController

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

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutAction:(id)sender {
    //delete core data
    
    UIAlertView *confirmView = [[UIAlertView alloc] initWithTitle:@"注销" message:@"确定要注销吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [confirmView show];
    confirmView = nil;
    //redirect to login page
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    // 通过storyboard id拿到目标控制器的对象
    //    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"RORLoginViewController"];
    //    //    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *msg = [[NSString alloc] initWithFormat:@"您点击的是第%d个按钮!",buttonIndex];
    NSLog(@"msg:%@",msg);
    if (buttonIndex == 0) {
        return;
    }else if(buttonIndex == 1){
        //[RORPublicMethods clearData];
        //[RORPublicMethods clearUser];
        //登录后刷新数据页面
        [RORPages refreshPages];

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
