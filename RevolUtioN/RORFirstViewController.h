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

@interface RORFirstViewController : UIViewController

@property (strong,nonatomic)NSManagedObjectContext *context;
@property (copy, nonatomic) NSString *userName;
@property (nonatomic) NSNumber *userId;
@property (weak, nonatomic) IBOutlet UIView *userInfoSubView;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIView *weatherSubView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *weatherInfoButtonView;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIView *nonPlanView;

- (IBAction)weatherInfoAction:(id)sender;
- (IBAction)normalRunAction:(id)sender;
- (IBAction)challengeRunAction:(id)sender;

@end
