//
//  RORAddFriendViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORMacro.h"

@interface RORAddFriendViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchTextField;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap :(id)sender;
@end
