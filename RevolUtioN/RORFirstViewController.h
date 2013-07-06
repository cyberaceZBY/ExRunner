//
//  RORFirstViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORLoginViewController.h"
#import "RORSettings.h"

#define tRouteMissionNameTag 1
#define tRouteMissionStartNameTag 2
#define tRouteMissionEndNameTag 3
#define tRouteMissionPointsTag 4
#define tRouteMissionExpTag 5
#define tRouteMissionCheckboxTag 6


@interface RORFirstViewController : UIViewController{
}
@property (weak, nonatomic) IBOutlet UIView *planView;
@property (strong,nonatomic)NSManagedObjectContext *context;
@property (copy, nonatomic) NSString *userName;
@property (nonatomic) NSNumber *userId;
@property (weak, nonatomic) IBOutlet UIView *userInfoSubView;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (strong, nonatomic) NSArray *routeMissions;
@property (weak, nonatomic) IBOutlet UIView *weatherSubView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *weatherInfoButtonView;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIView *nonPlanView;

@property (weak, nonatomic) IBOutlet UITableView *routeTableView;
@property (strong, nonatomic) NSMutableArray *missionList;

- (IBAction)weatherInfoAction:(id)sender;
- (void)updateView;

@end
