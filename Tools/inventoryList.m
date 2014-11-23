//
//  InventoryList.m
//  Tools
//
//  Created by Mazin Biviji on 11/21/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "InventoryList.h"

@interface InventoryList ()

@end

@implementation InventoryList

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
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        //does this work - i think it makes the app crash
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"task"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    
    //Set up Segemented Controller
    //Is it possible to also arrange by location?
    
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
        [self.tooltransfersArray addObject:object];
    } else if ([task isEqualToString:@"Add New Tool"] || [task isEqualToString:@"Tag Tool"]){
        [self.newtoolArray addObject:object];
    }
    
    return cell;
}

- (void)viewDidLoad {
    
    [self.SegmentedController insertSegmentWithTitle:@"Add/Tag Tools" atIndex:2 animated:false];
}

- (IBAction)SegmentControl:(UISegmentedControl *)sender {
    
    if (self.SegmentedController.selectedSegmentIndex == 0) {
        NSLog(@"All");
    } if (self.SegmentedController.selectedSegmentIndex == 1) {
        NSLog(@"Transfers");
        //[self.tableView cellForRowAtIndexPath:(self.tooltransfersArray)];
        //- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPathobject:(PFObject *)object {
        
    } if (self.SegmentedController.selectedSegmentIndex == 2) {
        NSLog(@"New Tools");
    } else {
        NSLog(@"");
    }
}

//

@end
