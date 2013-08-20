//
//  RORHistoryViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RORHistoryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *syncButtonItem;
@property (strong, nonatomic) NSMutableDictionary *runHistoryList;
@property (strong, nonatomic) NSMutableArray *dateList;
@property (strong, nonatomic) NSArray *sortedDateList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)syncAction:(id)sender;
- (IBAction)popBackAction:(id)sender;

@end
