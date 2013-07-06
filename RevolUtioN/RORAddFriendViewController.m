//
//  RORAddFriendViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORAddFriendViewController.h"

@interface RORAddFriendViewController ()

@end

@implementation RORAddFriendViewController
@synthesize searchTextField;

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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    identifier = @"plainCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UILabel *nameLabel = (UILabel*)[cell viewWithTag:1];
    UILabel *sexLabel = (UILabel *)[cell viewWithTag:2];
    
    nameLabel.text = @"Sn";
    sexLabel.text = @"male";
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"50米";
        default:
            break;
    }
    return nil;
}

- (void)viewDidUnload {
    [self setSearchTextField:nil];
    [super viewDidUnload];
}

- (IBAction)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender{
    [searchTextField resignFirstResponder];
}

@end
