//
//  ToolDetailViewController.h
//  Tools
//
//  Created by Mazin Biviji on 11/21/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ToolDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *examTitle;
@property (weak, nonatomic) PFObject *exam;

@end