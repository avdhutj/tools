//
//  STBCDelegate.m
//  Tools
//
//  Created by Mazin Biviji on 12/6/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "SupplierTabBarController.h"

#import "STBCDelegate.h"

@implementation STBCDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.viewController = [[SupplierTabBarController alloc] init];
    
    CameraViewController* vc1 = [[CameraViewController alloc] init];
    ToolListViewController* vc2 = [[ToolListViewController alloc] init];
    SupplierInventoryList* vc3 = [[SupplierInventoryList alloc] init];
    // Setting camera view controller state
    [vc1 setControllerState:CVC_SCAN_TOOL];
    
    UINavigationController *rvc1 = [[UINavigationController alloc] initWithRootViewController: vc1];
    UINavigationController *rvc2 = [[UINavigationController alloc] initWithRootViewController: vc2];
    UINavigationController *rvc3 = [[UINavigationController alloc] initWithRootViewController: vc3];
    
    NSArray* controllers = [NSArray arrayWithObjects:rvc1, rvc2, rvc3, nil];
    [self.viewController setViewControllers:controllers animated:NO];
    [_window addSubview:self.viewController.view];
    return YES;
    //self.selectedIndex = 0;
}

@end
