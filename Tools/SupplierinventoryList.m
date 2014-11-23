//
//  InventoryList.m
//  Tools
//
//  Created by Mazin Biviji on 11/21/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "SupplierInventoryList.h"

@interface SupplierInventoryList ()

@end

@implementation SupplierInventoryList

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        
        self.parseClassName = @"InvToolList";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 20;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
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
    NSString*task = [object objectForKey:@"task"];
    cell.detailTextLabel.text = [object objectForKey:@"task"];
    [self.alltasksArray addObject:object];
    if ([task isEqualToString:@"Ship Tool"] || [task isEqualToString:@"Recieve Tool"]){
        [self.updatetoolArray addObject:object];
    } else if ([task isEqualToString:@"Update Tool Info"]){
        [self.newtoolArray addObject:object];
        //Also need to add tools with incomplete info here
    }
    
    return cell;
}

@end
