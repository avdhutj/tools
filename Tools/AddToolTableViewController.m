//
//  AddToolTableViewController.m
//  Tools
//
//  Created by Mazin Biviji on 11/27/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "AddToolTableViewController.h"

@interface AddToolTableViewController ()

@end

@implementation AddToolTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //These values should be set in the prepare for segue function from the Scan tab
    PFQuery *query = [PFQuery queryWithClassName:@"SupplierList"];
    self.Supplier = [query getObjectWithId:@"Pj9iWujEKk"];
    self.QRCode = @"QRCode_123";
    
    //Set Up for the cells in the table
    self.items = @{@"Supplier" : @[[self.Supplier objectForKey:@"supplier"], [self.Supplier objectForKey:@"address"]],
                         @"Tool Details" : @[@"Tool ID", @"Weight", @"Tool type", @"Description"],
                         @"Part Numbers" : @[@"Part Number", @"Part Number", @"Part Number", @"Part Number", @"Part Number"]};
    self.tableTitles = [[self.items allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.tableTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.tableTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSString *sectionTitle = [self.tableTitles objectAtIndex:section];
    NSArray *sectionItems = [self.items objectForKey:sectionTitle];
    return [sectionItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    
    NSString *sectionTitle = [self.tableTitles objectAtIndex:indexPath.section];
    NSArray *sectionitems = [self.items objectForKey:sectionTitle];
    NSString *item = [sectionitems objectAtIndex:indexPath.row];
    
    if ([sectionTitle isEqualToString:@"Part Numbers"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellDetail" forIndexPath:indexPath];
        cell.textLabel.text = item;
        cell.detailTextLabel.text = @"Part Status";
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellLbl" forIndexPath:indexPath];
        cell.textLabel.text = item;
        return cell;
    }
    
}
- (IBAction)AddToolTouchUp:(id)sender {
    NSLog(@"Add Tool Btn");
    /*TO UPDATE!!!
    //Need to perform basic validation to ensure all cells are filled
    PFObject *tool = [PFObject objectWithClassName:@"Tools"];
    tool[@"supplier"] = self.Supplier.objectId;
    tool[@"toolId"] = self.ToolIdTxt.text;
    tool[@"weight"] = [NSNumber numberWithInt:[self.WeightTxt.text integerValue]];
    tool[@"toolDescription"] = self.DescrTxt.text;
    [tool saveInBackground];
    //Need to set up the part number adding thing this might be a little tricky because we will need to tool up the part number that was added and if it isnt there a new part number needs to be created after confirming with the user.*/
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    
    NSString *sectionTitle = [self.tableTitles objectAtIndex:indexPath.section];
    NSArray *sectionitems = [self.items objectForKey:sectionTitle];
    NSString *item = [sectionitems objectAtIndex:indexPath.row];
    
    if ([sectionTitle isEqualToString:@"Supplier"]) {
        return NO;
    }
    
    
    return YES;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
