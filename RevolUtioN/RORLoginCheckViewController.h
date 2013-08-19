//
//  RORLoginCheckViewController.h
//  RevolUtioN
//
//  Created by leon on 13-8-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import "RORShareService.h"

@interface RORLoginCheckViewController : UIViewController

- (IBAction)sinaWeiboLogin:(id)sender;
- (IBAction)tencentWeiboLogin:(id)sender;
- (IBAction)qqAccountLogin:(id)sender;
- (IBAction)renrenAccountLogin:(id)sender;

@end
