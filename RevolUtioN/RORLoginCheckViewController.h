//
//  RORLoginCheckViewController.h
//  RevolUtioN
//
//  Created by leon on 13-8-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import "User.h"
#import "RORUserServices.h"

@interface RORLoginCheckViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnSinaWeibo;

- (IBAction)sinaWeiboLogin:(id)sender;

@end
