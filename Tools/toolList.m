//
//  toolList.m
//  Tools
//
//  Created by Mazin Biviji on 11/21/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "toolList.h"
#import "ToolDetailViewController.h"

@interface toolList ()

@end

@implementation toolList

- (id)initWithCoder:(NSCoder *)bCoder {
    self = [super initWithCoder:bCoder];
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
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
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
    
    cell.textLabel.text = [object objectForKey:@"toolID"];
    
    return cell;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"displayDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
    
        // Set destination view controller to DetailViewController to avoid the NavigationViewController in the middle
        UINavigationController *nav = [segue destinationViewController];
        ToolDetailViewController *detailViewController = (ToolDetailViewController *) nav.topViewController;
        
        //ToolDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.exam = object;

    }

}

@end
