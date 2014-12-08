//
//  InventoryList.m
//  Tools
//
//  Created by Mazin Biviji on 11/21/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "SupplierInventoryList.h"
#import "AddToolTableViewController.h"

@interface SupplierInventoryList ()

@end

@implementation SupplierInventoryList

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        
        self.parseClassName = @"Tools";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 20;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"supplier" equalTo:[[PFUser currentUser] objectForKey:@"supplier"]];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a que   ry
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
        
    cell.textLabel.text = [object objectForKey:@"toolId"];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    

    if ([segue.identifier isEqualToString:@"displayDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        AddToolTableViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.exam = object;
        detailViewController.Supplier = self.Supplier;
        [detailViewController setControllerState:ATVC_VIEW_TOOL];
        
        
    }
    
}*/

@end
