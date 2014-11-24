//
//  LoginViewController.h
//  Tools
//
//  Created by Avdhut Joshi on 11/19/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *UserTextField;

@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *ResetBtn;

@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@end
