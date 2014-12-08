//
//  SupplierTabBarController.m
//  Tools
//
//  Created by Avdhut Joshi on 12/3/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "ReviewTabBarController.h"

@interface ReviewTabBarController ()

@end

@implementation ReviewTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITabBar *tabBar = self.tabBar;
    //Scan
    UITabBarItem *targetTabBarItem = [[tabBar items] objectAtIndex:0];
    UIImage *selectedIcon = [UIImage imageNamed:@"scanSelected.png"];
    UIImage *unSelectedImage = [UIImage imageNamed:@"scanUnSelected.png"];
    [targetTabBarItem setImage:[self imageWithImage:unSelectedImage scaledToSize:CGSizeMake(30, 30)]];
    [targetTabBarItem setSelectedImage:[self imageWithImage:selectedIcon scaledToSize:CGSizeMake(30, 30)]];
    targetTabBarItem.title = @"Scan";
    //Search
    UITabBarItem *targetTabBarItem1 = [[tabBar items] objectAtIndex:1];
    UIImage *selectedSearchIcon = [UIImage imageNamed:@"searchSelected.png"];
    UIImage *unSelectedSearchIcon = [UIImage imageNamed:@"searchUnSelected.png"];
    [targetTabBarItem1 setImage:[self imageWithImage:unSelectedSearchIcon scaledToSize:CGSizeMake(30, 30)]];
    [targetTabBarItem1 setSelectedImage:[self imageWithImage:selectedSearchIcon scaledToSize:CGSizeMake(30, 30)]];
    targetTabBarItem1.title = @"Search";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
