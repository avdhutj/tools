//
//  SupplierListViewController.m
//  Tools
//
//  Created by Avdhut Joshi on 12/1/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "SupplierListViewController.h"
#import <Parse/Parse.h>

@interface SupplierListViewController ()

@property (strong, nonatomic) NSMutableArray* supplierList;
-(void)loadData;
@end

@implementation SupplierListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_supplierList count];
}

-(void)loadData {
    PFQuery* query = [PFQuery queryWithClassName:@"SupplierList"];
    [query orderByAscending:@"supplier"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _supplierList = [[NSMutableArray alloc] initWithArray:objects];
        [self.tableView reloadData];
    }];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupplierCell" forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject* object = [_supplierList objectAtIndex:indexPath.row];
    cell.textLabel.text = [object valueForKey:@"supplier"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isAddToolTable) {
        PFObject* object = [_supplierList objectAtIndex:indexPath.row];
        [self.addToolController setSupplier:object];
        [self.addToolController UpdateSupplier];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (self.isToolList){
        NSLog(@"In send bacl to tool list");
        PFObject* object = [_supplierList objectAtIndex:indexPath.row];
        [self.ToolListVC setSelectedSupplier:object];
        [self.ToolListVC UpdateSupplier];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else {
        NSLog(@"else block - In tool list");
        PFObject* object = [_supplierList objectAtIndex:indexPath.row];
        [_inventoryListViewController setShippingSupplier:object];
        [self.navigationController popViewControllerAnimated:YES];
    }

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
