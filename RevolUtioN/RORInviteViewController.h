//
//  RORInviteViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RORInviteViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *locationTextFieldView;
@property (weak, nonatomic) IBOutlet UITextField *psTextFieldView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *datetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *missionLabel;
- (IBAction)editEndAction:(id)sender;
- (IBAction)tapOthersAction:(id)sender;

@end
