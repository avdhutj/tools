//
//  STBCDelegate.h
//  Tools
//
//  Created by Mazin Biviji on 12/6/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SupplierTabBarController;

@interface STBCDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SupplierTabBarController *viewController;

@end