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
#import "OEMTabViewController.h"
#import "SupplierTabBarController.h"
#import "ReviewTabBarController.h"

#import "CameraViewController.h"
#import "ToolListViewController.h"
#import "SupplierInventoryListViewController.h"

@interface LoginViewController ()

-(void)setupOEMTabBarController;
-(void)setupSupplierTabBarController;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [PFUser logOut];
    // Do any additional setup after loading the view.
    //Button Setup - why is the touch down event not working??
    UIImage *btnPressed = [UIImage imageNamed:@"BlueButtonPressed.png"];
    [self.LoginButton setImage:[self imageWithImage:btnPressed scaledToSize:CGSizeMake(410.0,60.0)] forState:UIControlStateSelected];
    //Login textboximage set up
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    self.UserTextField.leftView = paddingView;
    self.UserTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    self.PasswordTextField.leftView = paddingView2;
    self.PasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
}

-(void)viewDidAppear:(BOOL)animated {
    PFUser* currentUser = [PFUser currentUser];
    if (currentUser) {
        // Move to Next Screen
        if ([[currentUser valueForKey:@"type"] isEqualToString:@"oem"]) {
            [self setupOEMTabBarController];

        }
        else {
            [self setupSupplierTabBarController];
        }
    }
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
            [lView removeFromSuperview];
            if (user) {
                if ([[user valueForKey:@"type"] isEqualToString:@"oem"]) {

                    [self setupOEMTabBarController];
                }
                else if ([[user valueForKey:@"type"] isEqualToString:@"supplier"]) {
                    [self setupSupplierTabBarController];
                } else {
                    [self setupReviewTabBarController];
                }

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

-(void)setupReviewTabBarController {
    ReviewTabBarController* sTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewTabBarController"];
    
    CameraViewController* vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    ToolListViewController* vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ToolListViewController"];
    
    UINavigationController* nv1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UINavigationController* nv2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    [sTVC setViewControllers:[NSArray arrayWithObjects:nv1, nv2, nil]];
    
    [self presentViewController:sTVC animated:YES completion:^{
    }];
    
}

-(void)setupSupplierTabBarController {
    SupplierTabBarController* sTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SupplierTabBarController"];
    
    CameraViewController* vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    ToolListViewController* vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ToolListViewController"];
    SupplierInventoryListViewController* vc3 = [self.storyboard instantiateViewControllerWithIdentifier:@"SupplierInventoryListViewController"];
    
    UINavigationController* nv1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UINavigationController* nv2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UINavigationController* nv3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    
    [sTVC setViewControllers:[NSArray arrayWithObjects:nv1, nv2, nv3, nil]];
    
    [self presentViewController:sTVC animated:YES completion:^{
    }];
    
}

-(void)setupOEMTabBarController {
    OEMTabViewController* mTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OEMTabBarController"];
    [self presentViewController:mTVC animated:YES completion:^{
    }];
}

@end
