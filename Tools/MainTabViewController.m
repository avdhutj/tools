//
//  MainTabViewController.m
//  Tools
//
//  Created by Avdhut Joshi on 11/20/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "MainTabViewController.h"
#import "InventoryList.h"
#import "SupplierInventoryList.h"
#import <Parse/Parse.h>

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //set self.userType to demonstrate user rules
    //There should be two segues based on what the userType is to demonstrate user roles
    //self.userType = @"supplier";
    self.userType = @"oem";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
