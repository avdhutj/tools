//
//  SupplierListViewController.h
//  Tools
//
//  Created by Avdhut Joshi on 12/1/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryListViewController.h"
#import "ToolListViewController.h"
#import "AddToolTableViewController.h"

@interface SupplierListViewController : UITableViewController

@property (weak, nonatomic) InventoryListViewController* inventoryListViewController;

@property (weak, nonatomic) AddToolTableViewController* addToolController;

@property (weak, nonatomic) ToolListViewController* ToolListVC;

@property BOOL isAddToolTable;

@property BOOL isToolList;

@end
