//
//  RORLoadingViewController.m
//  RevolUtioN
//
//  Created by leon on 13-8-6.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORLoadingViewController.h"
#import "RORMissionServices.h"
#import "RORUserServices.h"

@interface RORLoadingViewController ()

@end

@implementation RORLoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //sync user
        NSNumber *userId = [RORUtils getUserId];
        if(userId > 0){
            [RORUserServices syncUserInfo:userId];
        }
        //sync missions
        [RORMissionServices syncMissions];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self performSegueWithIdentifier:@"loadingfinished" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
