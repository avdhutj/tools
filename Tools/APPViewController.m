//
//  APPViewController.m
//  CameraApp
//
//  Created by Rafael Garcia Leiva on 10/04/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "APPViewController.h"

@interface APPViewController ()

@end

@implementation APPViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Device has no camera"
                                                        delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    PFFile* img = [self.tool objectForKey:@"imageFile"];
    self.imageView.image = [UIImage imageWithData:[img getData]];
    
}

-(void)save:(id)sender {
    
    UIImage* img = self.imageView.image;
    CGImageRef cgref = [img CGImage];
    CIImage *cim = [img CIImage];

    if (cim == nil && cgref == NULL) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please take a photo or select an image to save" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        
    } else {
        
        NSData *imageData = UIImageJPEGRepresentation(img, 0.05f);
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [self uploadImage:imageData];
    }
}

-(void)uploadImage:(NSData *)imageData{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //Save Image (to update for add new tool)
            [self.tool setObject:imageFile forKey:@"imageFile"];
            [self.tool saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //Save Tool
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }progressBlock:^(int percentDone) {
        // To update progress spinner here. percentDone will be between 0 and 100.
        
    }];
     
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];

    
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
