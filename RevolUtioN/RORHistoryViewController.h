//
//  RORHistoryViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RORHistoryViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *syncButtonItem;
@property (strong, nonatomic) NSMutableDictionary *runHistoryList;
@property (strong, nonatomic) NSMutableArray *dateList;
@property (strong, nonatomic) NSArray *sortedDateList;

- (IBAction)syncAction:(id)sender;

@end
