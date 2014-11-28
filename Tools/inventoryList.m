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

-(void)viewDidLoad {
    [self.SegmentedController insertSegmentWithTitle:@"Add/Tag Tools" atIndex:2 animated:false];
    self.alltasksArray = [[NSMutableArray alloc] init];
    self.newtoolArray = [[NSMutableArray alloc] init];
    self.tooltransfersArray = [[NSMutableArray alloc] init];
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

-(void)objectsDidLoad:(NSError *)error {
    for (PFObject* object in self.objects) {
        NSString* task = [object objectForKey:@"task"];
        [self.alltasksArray addObject:object];
        if ([task isEqualToString:@"Ship Tool"] || [task isEqualToString:@"Recieve Tool"]) {
            [self.tooltransfersArray addObject:object];
        }
        if ([task isEqualToString:@"Add New Tool"] || [task isEqualToString:@"Tag Tool"]) {
            [self.newtoolArray addObject:object];
        }
    }
    [super objectsDidLoad:error];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.SegmentedController.selectedSegmentIndex == 0) {
        return self.alltasksArray.count;
    } else if (self.SegmentedController.selectedSegmentIndex == 1) {
        return self.tooltransfersArray.count;
    } else if (self.SegmentedController.selectedSegmentIndex == 2)
        return self.newtoolArray.count;
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"InvToolCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    PFObject* object;
    if (self.SegmentedController.selectedSegmentIndex == 0) {
        object = [self.alltasksArray objectAtIndex:indexPath.row];
    } else if (self.SegmentedController.selectedSegmentIndex == 1) {
        object = [self.tooltransfersArray objectAtIndex:indexPath.row];
    } else if (self.SegmentedController.selectedSegmentIndex == 2) {
        object = [self.newtoolArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = [object objectForKey:@"toolId"];
    cell.detailTextLabel.text = [object objectForKey:@"task"];
    
    return cell;
    
}


//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath
//                        object:(PFObject *)object {
//    
//    //Set up Segemented Controller
//    //Is it possible to also arrange by location?
//    
//    static NSString *CellIdentifier = @"InvToolCell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell.textLabel.text = [object objectForKey:@"toolId"];
//    
//    NSString* task = [object objectForKey:@"task"];
//    cell.detailTextLabel.text = [object objectForKey:@"task"];
//    [self.alltasksArray addObject:object];
//    if ([task isEqualToString:@"Ship Tool"] || [task isEqualToString:@"Recieve Tool"]){
//        [self.tooltransfersArray addObject:object];
//    } else if ([task isEqualToString:@"Add New Tool"] || [task isEqualToString:@"Tag Tool"]){
//        [self.newtoolArray addObject:object];
//    }
//    
//    return cell;
//}


- (IBAction)SegmentControl:(UISegmentedControl *)sender {
    
    if (self.SegmentedController.selectedSegmentIndex == 0) {
        NSLog(@"All");
    } else if (self.SegmentedController.selectedSegmentIndex == 1) {
        NSLog(@"Transfers");
    } else if (self.SegmentedController.selectedSegmentIndex == 2) {
        NSLog(@"New Tools");
    } else {
        NSLog(@"");
    }
    [self.tableView reloadData];
}

@end
