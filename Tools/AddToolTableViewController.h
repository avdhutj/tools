//
//  AddToolTableViewController.h
//  Tools
//
//  Created by Mazin Biviji on 11/27/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "InventoryListViewController.h"

@interface AddToolTableViewController : UITableViewController <UITableViewDelegate>

typedef NS_ENUM(NSInteger, ATVCControllerState) {
    ATVC_ADD_TOOL = 0,
    ATVC_EDIT_TOOL,
    ATVC_VIEW_TOOL
};

//Values set in the prepare to Segue function
@property (strong, nonatomic) PFObject *Supplier;
@property NSString* QRCode;
@property (strong, nonatomic) PFObject *exam;

//Table Set Up Values
@property NSMutableArray *tableTitles;
@property NSMutableDictionary *items;
@property NSArray *EditViewUpdatesArray;
@property NSMutableArray *AddedPartNumbers;

//Tool Attributes
@property (nonatomic) NSMutableArray *partNumbers;
@property (nonatomic) NSMutableDictionary *partStausLookUp;
@property (nonatomic) NSMutableArray *partPFObjects;
@property (nonatomic) NSString *toolStatus;

//Images
@property (nonatomic) UIImage *toolImage;
@property (nonatomic) UIImage *cameraImage;
@property (nonatomic) UIImage *cameraSelectedImage;
@property (nonatomic) UIImage *PhoneImage;
@property (nonatomic) UIImage *PhoneSelectedImage;


//PartNumebr Query (sent to Part No Cell to check for Part  status)
@property PFQuery* queryParts;


//Controller
@property (weak, nonatomic) IBOutlet UISegmentedControl *ToolFlagSegControl;
@property (nonatomic) UITextField* selectedTextFeild;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BackBtn;
@property (nonatomic) ATVCControllerState controllerState;
@property (weak, nonatomic) InventoryListViewController* inventoryViewController;

-(void)addPartNumberRow;
-(void)UpdateSupplier;

@end
