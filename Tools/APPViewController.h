//
//  APPViewController.h
//  CameraApp
//
//  Created by Rafael Garcia Leiva on 10/04/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface APPViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property PFObject *tool;

- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;

@end
