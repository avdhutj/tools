//
//  AddToolTableViewController.h
//  Tools
//
//  Created by Mazin Biviji on 11/27/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddToolTableViewController : UITableViewController

//Values set in the prepare to Segue function
@property (strong, nonatomic) PFObject *Supplier;
@property NSString* QRCode;

//Table Set Up Values
@property NSArray *tableTitles;
@property NSDictionary *items;

@property (weak, nonatomic) NSMutableArray *partNumbers;
@property (strong, nonatomic) PFObject *exam;
@property (weak, nonatomic) NSString *toolStatus;

@property (weak, nonatomic) IBOutlet UIButton *AddToolBtn;


@end
