//
//  RORUserInfoBasicViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RORUserInfoBasicViewController : UIViewController
@property (nonatomic, strong) NSDictionary *contentList;
@property (strong,nonatomic)NSManagedObjectContext *context;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSNumber *userId;

@property (strong, nonatomic) NSString *baseAcc;
@property (strong, nonatomic) NSString *crit;
@property (strong, nonatomic) NSString *inertiaAcc;
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSString *experience;

@property (strong, nonatomic) NSString *luck;
@property (strong, nonatomic) NSString *scores;

@property (strong, nonatomic) NSString *ErrorTip;

- (id)initWithPageNumber:(NSUInteger)page;
@end
