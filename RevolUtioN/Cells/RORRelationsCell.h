//
//  RORRelationsCell.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-10.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#define rNameLabelTag 1
#define rSexLabelTag 2

@interface RORRelationsCell : UITableViewCell

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *distance;

@end
