//
//  InventoryListViewController.h
//  Tools
//
//  Created by Aasawari Deshpande on 11/28/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TaskType) {
    TT_SCAN_TOOL = 0,
    TT_ADD_TOOL,
    TT_SHIP_TOOL,
    TT_RECIEVE_TOOL,
    TT_UPDATE_TOOL
};

@interface InventoryListViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentController;

@end
