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
#import "LoadView.h"
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
    
    /*
    UIImage *btnDown = [UIImage imageNamed:@"LightPurpleButtonDown.png"];
    
    [self.LoginButton setImage:[self imageWithImage:btnDown scaledToSize:CGSizeMake(410.0, 60.0)]forState:UIControlStateNormal];
    
    UIImage *btnUp = [UIImage imageNamed:@"LightPurpleButtonUp.png"];
    
    [self.LoginButton setImage:[self imageWithImage:btnUp scaledToSize:CGSizeMake(410.0, 60.0)] forState:UIControlStateHighlighted];
    
    UIImage *btnPressed = [UIImage imageNamed:@"LightPurpleButtonPressed.png"];
    [self.LoginButton setImage:[self imageWithImage:btnPressed scaledToSize:CGSizeMake(410.0,60.0)] forState:UIControlStateSelected];*/
    
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
//        LoadingView* lView = [[LoadingView alloc] initWithFrame:CGRectMake(self.view.center.x - 50, self.view.center.y - 10,
//                                                                        100, 20)];
//        [self.view addSubview:lView];
        
        LoadView* lView = [[[NSBundle mainBundle] loadNibNamed:@"LoadView" owner:nil options:nil] lastObject];
        
        [self.view addSubview:lView];
        
        [PFUser logInWithUsernameInBackground:self.UserTextField.text password:self.PasswordTextField.text block:^(PFUser *user, NSError *error) {
//            [_loadView removeFromSuperview];
            [lView removeFromSuperview];
            if (user) {
                
                MainTabViewController* mTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                [self presentViewController:mTVC animated:YES completion:^{
                    
                }];
//                [self showViewController:mTVC sender:self];
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
