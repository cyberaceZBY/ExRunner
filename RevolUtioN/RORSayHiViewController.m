//
//  RORSayHiViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSayHiViewController.h"

@interface RORSayHiViewController ()

@end

@implementation RORSayHiViewController
@synthesize sayhiTextField;

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

- (IBAction)backgroundTap:(id)sender{
    [sayhiTextField resignFirstResponder];
}

- (IBAction)textfieldDoneEditing:(id)sender{
    [sayhiTextField resignFirstResponder];
}

- (void)viewDidUnload {
    [self setSayhiTextField:nil];
    [super viewDidUnload];
}




@end
