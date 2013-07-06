//
//  RORPeriodicPickerViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RORPeriodicPickerViewController : UITableViewController

@property (strong, nonatomic) NSArray* periodicList;
@property (strong, nonatomic) NSNumber *startingMissionId;
@property (retain, nonatomic) UIViewController *delegate;

- (IBAction)okAction:(id)sender;

@end
