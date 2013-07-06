//
//  RORSayHiViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RORSayHiViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIControl *sayhiTextField;
- (IBAction)backgroundTap :(id)sender;
- (IBAction)textfieldDoneEditing:(id)sender;


@end
