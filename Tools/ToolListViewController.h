//
//  ToolList.h
//  Tools
//
//  Created by Mazin Biviji on 11/21/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ToolListViewController : UITableViewController<UIScrollViewDelegate>

@property (strong, nonatomic) PFObject *selectedSupplier;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

-(void)UpdateSupplier;

@end
