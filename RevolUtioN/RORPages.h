//
//  RORPages.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-26.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RORPages : NSObject

+ (void) setMainPage:(UIViewController *)viewController;
+ (void) setFriendPage:(UIViewController *)viewController;
//+ (void) setFirstPage:(UIViewController *)viewController;

+ (UIViewController*) getMainPage;
+ (UIViewController*) getFriendPage;

+ (void)refreshPages;
@end
