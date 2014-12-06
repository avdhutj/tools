//
//  InventoryListViewController.h
//  Tools
//
//  Created by Aasawari Deshpande on 11/28/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

typedef NS_ENUM(NSInteger, TaskType) {
    TT_SCAN_TOOL = 0,
    TT_ADD_TOOL,
    TT_SHIP_TOOL,
    TT_RECIEVE_TOOL,
    TT_UPDATE_TOOL
};

typedef NS_ENUM(NSInteger, ILControllerState) {
    IL_CAMERA = 0,
    IL_TAG_TOOL,
    IL_ADD_TOOL,
    IL_SHIP_TOOL,
    IL_RECIEVE_TOOL,
    IL_UPDATE_TOOL,
    IL_NONE
};


@interface InventoryListViewController : UITableViewController<UIAlertViewDelegate>


@property (strong, nonatomic) NSString* qrCodeString;
@property (strong, nonatomic) PFObject* shippingSupplier;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentController;
@end
