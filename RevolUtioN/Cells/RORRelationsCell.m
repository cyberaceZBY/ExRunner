//
//  RORRelationsCell.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-10.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORRelationsCell.h"

@implementation RORRelationsCell
@synthesize name;
@synthesize sex;
@synthesize distance;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect nameLabelRect = CGRectMake(10, 5, 70, 20);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.tag = rNameLabelTag;
        //nameLabel.text = @"Bjorn";
        nameLabel.font = [UIFont systemFontOfSize:17];
        [[self contentView] addSubview: nameLabel];
        
        CGRect sexLabelRect = CGRectMake(10, 26, 70, 15);
        UILabel *sexLabel = [[UILabel alloc] initWithFrame:sexLabelRect];
        sexLabel.textAlignment = UITextAlignmentLeft;
        sexLabel.tag = rSexLabelTag;
        //sexLabel.text = @"male";
        sexLabel.font = [UIFont systemFontOfSize:12];
        sexLabel.textColor = [UIColor lightGrayColor];
        [[self contentView] addSubview: sexLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setName:(NSString *)n {
    if (![n isEqualToString:name]){
        name = [n copy];
        UILabel *nameLabel = (UILabel *) [self.contentView viewWithTag:rNameLabelTag];
        nameLabel.text = name;
    }
}

- (void) setSex:(NSString *)s {
    if (![s isEqualToString:sex]){
        sex = [s copy];
        UILabel *sexLabel = (UILabel *) [self.contentView viewWithTag:rSexLabelTag];
        sexLabel.text = sex;
    }
}
@end
