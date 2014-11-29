//
//  InventoryListViewController.m
//  Tools
//
//  Created by Aasawari Deshpande on 11/28/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "InventoryListViewController.h"
#import <Parse/Parse.h>
#import "LoadView.h"

@interface InventoryListViewController ()

@property (strong, nonatomic) NSMutableArray* allToolsArray;
@property (strong, nonatomic) NSMutableArray* transferToolsArray;
@property (strong, nonatomic) NSMutableArray* addToolsArray;

-(void)loadData;

@end

@implementation InventoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _allToolsArray = [[NSMutableArray alloc] init];
    _transferToolsArray = [[NSMutableArray alloc] init];
    _addToolsArray = [[NSMutableArray alloc] init];
    
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

    if (self.segmentController.selectedSegmentIndex == 0) {
        return _allToolsArray.count;
    }
    else if (self.segmentController.selectedSegmentIndex == 1) {
        return _transferToolsArray.count;
    }
    else if (self.segmentController.selectedSegmentIndex == 2) {
        return _addToolsArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvToolCell" forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject* object;
    if (self.segmentController.selectedSegmentIndex == 0) {
        object = [_allToolsArray objectAtIndex:indexPath.row];
        
    }
    else if (self.segmentController.selectedSegmentIndex == 1) {
        object = [_transferToolsArray objectAtIndex:indexPath.row];
    }
    else if (self.segmentController.selectedSegmentIndex == 2) {
        object = [_addToolsArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = [object valueForKey:@"toolId"];
    cell.detailTextLabel.text = [object valueForKey:@"task"];
    return cell;
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

-(void)loadData {
    PFQuery* query = [PFQuery queryWithClassName:@"InvToolList"];
    [query orderByAscending:@"taskType"];
    
    LoadView* lView = [[[NSBundle mainBundle] loadNibNamed:@"LoadView" owner:nil options:nil] lastObject];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [lView removeFromSuperview];
        for (PFObject* object in objects) {
            [_allToolsArray addObject:object];
            if ([[object valueForKey:@"taskType"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [_addToolsArray addObject:object];
            }
            else if ([[object valueForKey:@"taskType"] isEqualToNumber:[NSNumber numberWithInt:2]]) {
                [_transferToolsArray addObject:object];
            }
            else if ([[object valueForKey:@"taskType"] isEqualToNumber:[NSNumber numberWithInt:3]]) {
                [_transferToolsArray addObject:object];
            }
        }
        [self.tableView reloadData];
    }];

}
- (IBAction)segmentControllerChanged:(id)sender {
    [self.tableView reloadData];
}



@end
