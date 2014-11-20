//
//  LoginViewController.m
//  Tools
//
//  Created by Avdhut Joshi on 11/19/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "LoadingView.h"
#import "MainTabViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser* currentUser = [PFUser currentUser];
    if (currentUser) {
        // Move to Next Screen
        [PFUser logOut];
    }
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
- (IBAction)LoginClicked:(id)sender {
    if (![self.UserTextField.text isEqualToString:@""] && ![self.PasswordTextField.text isEqualToString:@""]) {
        LoadingView* lView = [[LoadingView alloc] initWithFrame:CGRectMake(self.view.center.x - 50, self.view.center.y - 10,
                                                                           100, 20)];
        [self.view addSubview:lView];
        
        [PFUser logInWithUsernameInBackground:self.UserTextField.text password:self.PasswordTextField.text block:^(PFUser *user, NSError *error) {
            [lView removeFromSuperview];
            if (user) {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Login Successful" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
//                MainTabViewController* mTVC = [[MainTabViewController alloc] init];
//                [self showViewController:mTVC sender:self];
                MainTabViewController* mTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                [self showViewController:mTVC sender:self];
            }
            else {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Login Error!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    } else {
        // Error Alert
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please Enter Username and Password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
