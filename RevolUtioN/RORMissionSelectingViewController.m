//
//  RORMissionSelectingViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMissionSelectingViewController.h"

@interface RORMissionSelectingViewController ()

@end

@implementation RORMissionSelectingViewController
@synthesize contentList;
@synthesize tag;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tag = -1;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    contentList = [[NSMutableArray alloc] initWithObjects:@"0", @"1", @"2", @"3", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return contentList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == tag)
        return 100;
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"plainCell";
    
//    if (indexPath.row == tag) {
//        CellIdentifier = @"detailCell";
//    };
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel* label = (UILabel*)[cell viewWithTag:1];

    label.text = [contentList objectAtIndex:indexPath.row];
//    label.text = [NSString stringWithFormat:@"%@%d",@"任务",indexPath.row];
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */

//    if (tag!=indexPath.row){
//        if (indexPath.row > tag && tag>=0){
//            tag = indexPath.row-1;
//        } else
//            tag = indexPath.row;
////        [contentList insertObject:@"extend" atIndex:tag+1];
//        tableView.scrollEnabled = NO;
//    } else {
//        tag = -1;
//        tableView.scrollEnabled = YES;
//    }
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

//    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSRangeFromString(@"0 1")];
//    [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];

    if (tag==indexPath.row){
        tag = -1;
    }else{
        tag = indexPath.row;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect rect = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, tableView.frame.size.height);
    NSArray *indexPathArray = [tableView indexPathsForRowsInRect:rect];
    [tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    
}

@end
