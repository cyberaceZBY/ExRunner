//
//  RORPages.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-26.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORPages.h"
#import "RORFirstViewController.h"
#import "RORSecondViewController.h"

@implementation RORPages

static RORFirstViewController *MainPage;
static RORSecondViewController *FriendPage;


+ (void) setMainPage:(RORFirstViewController *)viewController{
    MainPage = viewController;
}

+ (void) setFriendPage:(RORSecondViewController *)viewController{
    FriendPage = viewController;
}

+ (UIViewController*) getMainPage{
    return MainPage;
}

+ (UIViewController*) getFriendPage{
    return FriendPage;
}

+ (void)refreshPages{
    if (MainPage != nil)
        [MainPage viewDidLoad];
    if (FriendPage != nil)
        [FriendPage viewDidLoad];
}

@end

