//
//  RORUserInfoBasicViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORUserInfoBasicViewController.h"
#import "User_Attributes.h"
#import "RORAppDelegate.h"
#import "RORUtils.h"
#import "RORConstant.h"

#define LEVELTAG 1
#define POINTTAG 2
#define RANKTAG 3
#define BASICACCTAG 4
#define INERTIAACCTAG 5
#define DOUBLERATETAG 6
#define LUCKTAG 7
#define HEADTAG 8
#define CHESTTAG 9
#define ARMTAG 10
#define LEGTAG 11
#define WAISTTAG 12
#define FOOTTAG 13

@interface RORUserInfoBasicViewController (){
    int pageNum;
}

@end

@implementation RORUserInfoBasicViewController
@synthesize contentList;
@synthesize context, userName, userId, ErrorTip;
@synthesize baseAcc, crit, inertiaAcc, level, luck, scores, experience;

- (id)initWithPageNumber:(NSUInteger)page
{
    if (self = [super initWithNibName:@"UserInfoBasicView" bundle:nil])
    {
        pageNum = page;
    }
    return self;
}

- (void)viewDidLoad
{
//    NSMutableString *labelText;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
////=============Core data===========    
//    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication]delegate];
//    
//    context = delegate.managedObjectContext;
//    
//    User_Attributes *userAttr = [NSEntityDescription insertNewObjectForEntityForName:@"User_Attributes" inManagedObjectContext:context];
//    userAttr.userId = [[NSNumber alloc] initWithInt:1];
//    userAttr.level = [[NSNumber alloc ] initWithDouble:1.0];
//
//    NSError *error = nil;
//    
//    if (![context save:&error]) {
//        
//        NSLog(@"%@",[error localizedDescription]);
//        
//    }
//    
//    
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
//    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Attributes"inManagedObjectContext:context];
//    
//    [fetchRequest setEntity:entity];
//    
//    
//    
//    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
//    
//    for (NSManagedObject *info in fetchObject) {
//        
//        NSLog(@"id:%@",[info valueForKey:@"id"]);
//        
//        NSLog(@"name:%@",[info valueForKey:@"level"]);
//        
//    }
//    //========================
    
//    NSString *path= [RORUtils getUserInfoPList];
    
//    self.contentList = [NSDictionary dictionaryWithContentsOfFile:path];
//    UILabel* label = (UILabel*)[self.view viewWithTag:LEVELTAG];
//    label.text = [contentList valueForKey:@"level"];
//    label = (UILabel*)[self.view viewWithTag:POINTTAG];
//    label.text = [contentList valueForKey:@"point"];
//    label = (UILabel*)[self.view viewWithTag:RANKTAG];
//    label.text = [contentList valueForKey:@"rank"];
//    
//    label = (UILabel*)[self.view viewWithTag:BASICACCTAG];
//    basic = (NSString *)[contentList valueForKey:@"basicAcc"];
//    eqp = (NSString *)[contentList valueForKey:@"basicAccEqp"];
//    labelText = [NSMutableString string];
//    [labelText appendString:basic];
//    [labelText appendString:@"+"];
//    [labelText appendString:eqp];
//    label.text = labelText;
//    label = (UILabel*)[self.view viewWithTag:INERTIAACCTAG];
//    basic = (NSString *)[contentList valueForKey:@"inertiaAcc"];
//    label.text = basic;
//    label = (UILabel*)[self.view viewWithTag:DOUBLERATETAG];
//    basic = (NSString *)[contentList valueForKey:@"doubleRate"];
//    eqp = (NSString *)[contentList valueForKey:@"doubleRateEqp"];
//    labelText = [NSMutableString string];
//    [labelText appendString:basic];
//    [labelText appendString:@"+"];
//    [labelText appendString:eqp];
//    label.text = labelText;
//    label = (UILabel*)[self.view viewWithTag:LUCKTAG];
//    basic = (NSString *)[contentList valueForKey:@"luck"];
//    eqp = (NSString *)[contentList valueForKey:@"luckEqp"];
//    labelText = [NSMutableString string];
//    [labelText appendString:basic];
//    [labelText appendString:@"+"];
//    [labelText appendString:eqp];
//    label.text = labelText;
//    
//    NSDictionary *equip = (NSDictionary*)[contentList valueForKey:@"equip"];
//    label = (UILabel*)[self.view viewWithTag:HEADTAG];
//    label.text = [equip valueForKey:@"head"];
//    label = (UILabel*)[self.view viewWithTag:CHESTTAG];
//    label.text = [equip valueForKey:@"chest"];
//    label = (UILabel*)[self.view viewWithTag:ARMTAG];
//    label.text = [equip valueForKey:@"arm"];
//    label = (UILabel*)[self.view viewWithTag:LEGTAG];
//    label.text = [equip valueForKey:@"leg"];
//    label = (UILabel*)[self.view viewWithTag:WAISTTAG];
//    label.text = [equip valueForKey:@"waist"];
//    label = (UILabel*)[self.view viewWithTag:FOOTTAG];
//    label.text = [equip valueForKey:@"foot"];
    
    ErrorTip = [NSString stringWithFormat:@""];
    NSString *url = [NSString stringWithFormat:@"%@/account/%d",SERVICE_URL ,[self.userId integerValue]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //    将请求的url数据放到NSData对象中
    NSHTTPURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSInteger statCode = [urlResponse statusCode];
    NSLog(@"user info request:%@, code:%d", self.userName, statCode);
    NSError *error = nil;
    if (statCode == 200){
        NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
        //            NSDictionary *userInfo = [userInfoDic objectForKey:@"weatherinfo"];
        //[RORUtils loadUserInfoFromDict:userInfoDic];
        NSLog(@"%@", [userInfoDic description]);
    } else {
        ErrorTip = @"(非实时数据)";
        return;
    }

    
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    context = delegate.managedObjectContext;
    //init user basic info
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Attributes" inManagedObjectContext:context];
//    NSInteger userId_int = [userId integerValue];
    [fetchRequest setEntity:entity];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    User_Attributes *userAttr = nil;
    for (NSManagedObject *info in fetchObject) {
        if ([[info valueForKey:@"userId"] isEqualToNumber:self.userId]) {
            userAttr = (User_Attributes *)info;//
            break;
        }
    }
    if (userAttr != nil){
        level = [NSString stringWithFormat:@"%@", userAttr.level];
        crit = [NSString stringWithFormat:@"%@", userAttr.crit];
        baseAcc = [NSString stringWithFormat:@"%@", userAttr.baseAcc];
        inertiaAcc = [NSString stringWithFormat:@"%@", userAttr.inertiaAcc];
        luck = [NSString stringWithFormat:@"%@", userAttr.luck];
        scores = [NSString stringWithFormat:@"%@", userAttr.scores];
        experience = [NSString stringWithFormat:@"%@", userAttr.experience];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 4;
        default:
            break;
    }
    return -1;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"defaultCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    UILabel *keyLabel = cell.textLabel;
    UILabel *valueLabel = cell.detailTextLabel;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    keyLabel.text = @"等级";
                    valueLabel.text = level;
                    break;
                case 1:
                    keyLabel.text = @"经验值";
                    valueLabel.text = experience;
                    break;
                case 2:
                    keyLabel.text = @"积分";
                    valueLabel.text = scores;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    keyLabel.text = @"基础加速";
                    valueLabel.text = baseAcc;
                    break;
                case 1:
                    keyLabel.text = @"惯性加速";
                    valueLabel.text = inertiaAcc;
                    break;
                case 2:
                    keyLabel.text = @"爆击等级";
                    valueLabel.text = crit;
                    break;
                case 3:
                    keyLabel.text = @"幸运等级";
                    valueLabel.text = luck;
                    break;
                default:
                    break;
            }
            break;

        default:
            break;
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"%@ %@",@"基本",ErrorTip];
        case 1:
            return [NSString stringWithFormat:@"%@ %@",@"属性",ErrorTip];
        default:
            break;
    }
    return nil;
}

@end
