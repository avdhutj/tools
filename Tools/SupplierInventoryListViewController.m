//
//  SupplierInventoryListViewController.m
//  Tools
//
//  Created by Avdhut Joshi on 12/7/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "SupplierInventoryListViewController.h"
#import "AddToolTableViewController.h"
#import "LoadView.h"
#import <Parse/Parse.h>

@interface SupplierInventoryListViewController ()
@property (strong, nonatomic) NSMutableArray* allToolsArray;
@property (strong, nonatomic) NSMutableArray* infoToolsArray;
@property (strong, nonatomic) NSMutableArray* partToolsArray;
@property (strong, nonatomic) NSMutableArray* scrapToolsArray;
@property (strong, nonatomic) NSMutableArray* otherToolsArray;

-(void)loadData;

@end

@implementation SupplierInventoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _allToolsArray = [[NSMutableArray alloc] init];
    _infoToolsArray = [[NSMutableArray alloc] init];
    _partToolsArray = [[NSMutableArray alloc] init];
    _scrapToolsArray = [[NSMutableArray alloc] init];
    _otherToolsArray = [[NSMutableArray alloc] init];
    
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
    if (_segmentControl.selectedSegmentIndex == 0) {
        return [_allToolsArray count];
    }
    if (_segmentControl.selectedSegmentIndex == 1) {
        return [_infoToolsArray count];
    }
    if (_segmentControl.selectedSegmentIndex == 2) {
        return [_partToolsArray count];
    }
    if (_segmentControl.selectedSegmentIndex == 3) {
        return [_scrapToolsArray count];
    }
    if (_segmentControl.selectedSegmentIndex == 4) {
        return [_otherToolsArray count];
    }
    return 0;
}

-(void)loadData {
    PFQuery* query = [PFQuery queryWithClassName:@"Tools"];
    [query whereKey:@"supplier" equalTo:[[PFUser currentUser] objectForKey:@"supplier"]];
    LoadView* lView = [[[NSBundle mainBundle] loadNibNamed:@"LoadView" owner:nil options:nil] lastObject];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [lView removeFromSuperview];
        for (PFObject* object in objects) {
            if ([[object valueForKey:@"flag"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [_infoToolsArray addObject:object];
                [_allToolsArray addObject:object];
            }
            else if ([[object valueForKey:@"flag"] isEqualToNumber:[NSNumber numberWithInt:2]]) {
                [_partToolsArray addObject:object];
                [_allToolsArray addObject:object];
            }
            else if ([[object valueForKey:@"flag"] isEqualToNumber:[NSNumber numberWithInt:3]]) {
                [_scrapToolsArray addObject:object];
                [_allToolsArray addObject:object];
            }
            else if ([[object valueForKey:@"flag"] isEqualToNumber:[NSNumber numberWithInt:4]]) {
                [_otherToolsArray addObject:object];
                [_allToolsArray addObject:object];
            }
        }
        [self.tableView reloadData];
    }];
}
- (IBAction)segmentControlChanged:(id)sender {
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject* object;
    if ([_segmentControl selectedSegmentIndex] == 0) {
        object = [_allToolsArray objectAtIndex:indexPath.row];
    }
    else if ([_segmentControl selectedSegmentIndex] == 1) {
        object = [_infoToolsArray objectAtIndex:indexPath.row];
    }
    else if ([_segmentControl selectedSegmentIndex] == 2) {
        object = [_partToolsArray objectAtIndex:indexPath.row];
    }
    else if ([_segmentControl selectedSegmentIndex] == 3) {
        object = [_scrapToolsArray objectAtIndex:indexPath.row];
    }
    else if ([_segmentControl selectedSegmentIndex] == 4) {
        object = [_otherToolsArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = [object valueForKey:@"toolId"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject* selectedObject;
    if ([_segmentControl selectedSegmentIndex] == 0) {
        selectedObject = [_allToolsArray objectAtIndex:indexPath.row];
    }
    else if ([_segmentControl selectedSegmentIndex] == 1) {
        selectedObject = [_infoToolsArray objectAtIndex:indexPath.row];
    }
    else if ([_segmentControl selectedSegmentIndex] == 2) {
        selectedObject = [_partToolsArray objectAtIndex:indexPath.row];
    }
    else if ([_segmentControl selectedSegmentIndex] == 3) {
        selectedObject = [_scrapToolsArray objectAtIndex:indexPath.row];
    }
    else if ([_segmentControl selectedSegmentIndex] == 4) {
        selectedObject = [_otherToolsArray objectAtIndex:indexPath.row];
    }
    AddToolTableViewController* aTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddToolTableViewController"];
    [aTVC setExam:selectedObject];
    [aTVC setControllerState:ATVC_VIEW_TOOL];
    
    [self.navigationController pushViewController:aTVC animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
