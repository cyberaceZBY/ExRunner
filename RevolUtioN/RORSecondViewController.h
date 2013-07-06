//
//  RORSecondViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#define rNameLabelTag 1
#define rSubLabelTag 2

@interface RORSecondViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *people;
@property (strong, nonatomic) NSMutableArray *invitation;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSNumber *userId;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addFriendButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *coverView;

@end
