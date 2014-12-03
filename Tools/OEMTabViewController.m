//
//  MainTabViewController.m
//  Tools
//
//  Created by Avdhut Joshi on 11/20/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "OEMTabViewController.h"
#import "SupplierInventoryList.h"
#import "CameraViewController.h"
#import <Parse/Parse.h>

@interface OEMTabViewController ()

@end

@implementation OEMTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //set self.userType to demonstrate user rules
    //There should be two segues based on what the userType is to demonstrate user roles
    //self.userType = @"supplier";
    self.userType = @"oem";
    
    UITabBar *tabBar = self.tabBar;
    //Scan
    UITabBarItem *targetTabBarItem = [[tabBar items] objectAtIndex:0];
    UIImage *selectedIcon = [UIImage imageNamed:@"scanSelected.png"];
    UIImage *unSelectedImage = [UIImage imageNamed:@"scanUnSelected.png"];
    [targetTabBarItem setImage:[self imageWithImage:unSelectedImage scaledToSize:CGSizeMake(30, 30)]];
    [targetTabBarItem setSelectedImage:[self imageWithImage:selectedIcon scaledToSize:CGSizeMake(30, 30)]];
    //Search
    UITabBarItem *targetTabBarItem1 = [[tabBar items] objectAtIndex:1];
    UIImage *selectedSearchIcon = [UIImage imageNamed:@"searchSelected.png"];
    UIImage *unSelectedSearchIcon = [UIImage imageNamed:@"searchUnSelected.png"];
    [targetTabBarItem1 setImage:[self imageWithImage:unSelectedSearchIcon scaledToSize:CGSizeMake(30, 30)]];
    [targetTabBarItem1 setSelectedImage:[self imageWithImage:selectedSearchIcon scaledToSize:CGSizeMake(30, 30)]];
    //Inv
    UITabBarItem *targetTabBarItem2 = [[tabBar items] objectAtIndex:2];
    UIImage *selectedInvIcon = [UIImage imageNamed:@"InvSelected.png"];
    UIImage *unInvSelectedImage = [UIImage imageNamed:@"InvUnSelected.png"];
    [targetTabBarItem2 setImage:[self imageWithImage:unInvSelectedImage scaledToSize:CGSizeMake(30, 30)]];
    [targetTabBarItem2 setSelectedImage:[self imageWithImage:selectedInvIcon scaledToSize:CGSizeMake(30, 30)]];
    //buttons
    
    // Setting camera view controller state
    CameraViewController* cVC = [[self.tabBarController viewControllers] objectAtIndex:0];
    [cVC setControllerState:CVC_SCAN_TOOL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Navigation (need to work on this)

/*Need to update to one view or ther other based on user type
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"displayDetail"]) {
        
        // Set destination view controller to DetailViewController to avoid the NavigationViewController in the middle
        UINavigationController *nav = [segue destinationViewController];
        ToolDetailViewController *detailViewController = (ToolDetailViewController *) nav.topViewController;
        
        //ToolDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.exam = object;
        
    }
    
 }*/

@end
