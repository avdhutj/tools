//
//  InventoryList.h
//  Tools
//
//  Created by Mazin Biviji on 11/21/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface InventoryList : PFQueryTableViewController

@property (weak, nonatomic) NSString* userType;
@property (weak, nonatomic) NSMutableArray* alltasksArray;
@property (weak, nonatomic) NSMutableArray* tooltransfersArray;
@property (weak, nonatomic) NSMutableArray* newtoolArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentedController;


@end
