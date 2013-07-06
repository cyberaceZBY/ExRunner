//
//  RORDatetimeViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-4.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORDatetimeViewController.h"
#import "RORInviteViewController.h"

@interface RORDatetimeViewController ()

@end

@implementation RORDatetimeViewController
@synthesize delegate;
@synthesize picker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitAction:(id)sender {
    RORInviteViewController * controller = (RORInviteViewController *)delegate;
    NSDate *curDate =[picker date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
//    formate.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formate setDateStyle:NSDateFormatterFullStyle];
    [formate setTimeStyle:NSDateFormatterShortStyle];
    NSString *formateDateString = [formate stringFromDate:curDate];
    controller.datetimeLabel.text = [NSString stringWithFormat:@"%@", formateDateString];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setPicker:nil];
    [super viewDidUnload];
}
@end
