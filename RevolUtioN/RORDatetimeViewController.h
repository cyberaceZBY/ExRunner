//
//  RORDatetimeViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-4.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RORDatetimeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
@property (weak, nonatomic) id delegate;
- (IBAction)submitAction:(id)sender;

@end
