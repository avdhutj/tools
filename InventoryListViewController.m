//
//  InventoryListViewController.m
//  Tools
//
//  Created by Aasawari Deshpande on 11/28/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "InventoryListViewController.h"
#import "AddToolTableViewController.h"
#import "CameraViewController.h"
#import <Parse/Parse.h>
#import "LoadView.h"

@interface InventoryListViewController () {

}

@property (strong, nonatomic) PFObject* selectedObject;
@property (strong, nonatomic) NSMutableArray* allToolsArray;
@property (strong, nonatomic) NSMutableArray* transferToolsArray;
@property (strong, nonatomic) NSMutableArray* addToolsArray;

@property (strong, nonatomic) NSMutableSet* doneSet;

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
    
    _doneSet = [[NSMutableSet alloc] init];
    
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
    
    if ([_doneSet containsObject:[object objectId]]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    cell.textLabel.text = [object valueForKey:@"toolId"];
    cell.detailTextLabel.text = [object valueForKey:@"task"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentController.selectedSegmentIndex == 0) {
        self.selectedObject = [_allToolsArray objectAtIndex:indexPath.row];
        CameraViewController* cVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
        if ([[_selectedObject valueForKey:@"taskType"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [cVC setInvToolId:[_selectedObject valueForKey:@"toolId"]];
            [cVC setControllerState:CVC_INV_TAG_TOOL];
        }
        else if ([[_selectedObject valueForKey:@"taskType"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [cVC setControllerState:CVC_INV_ADD_TOOL];
        }
        else if ([[_selectedObject valueForKey:@"taskType"] isEqualToNumber:[NSNumber numberWithInt:2]]) {
            [cVC setControllerState:CVC_INV_SHIP_TOOL];
        }
        else if ([[_selectedObject valueForKey:@"taskType"] isEqualToNumber:[NSNumber numberWithInt:3]]) {
            [cVC setControllerState:CVC_INV_RECIEVE_TOOL];
        }
        else if ([[_selectedObject valueForKey:@"taskType"] isEqualToNumber:[NSNumber numberWithInt:4]]) {
            [cVC setControllerState:CVC_INV_UPDATE_TOOL];
        }
//        [self.navigationController pushViewController:cVC animated:YES];
        [cVC setInventoryListViewController:self];
        [self presentViewController:cVC animated:YES completion:^{
            
        }];
    }
}

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
    _selectedObject = nil;
    [self.tableView reloadData];
}

-(void)HandleTagTool:(NSString*)qrCodeString {
    LoadView* lView = [[[NSBundle mainBundle] loadNibNamed:@"LoadView" owner:nil options:nil] lastObject];
    [self.view addSubview:lView];
    NSString* toolId = [_selectedObject objectForKey:@"toolId"];
    PFQuery* query = [PFQuery queryWithClassName:@"Tools"];
    [query whereKey:@"toolId" equalTo:toolId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            [lView removeFromSuperview];
            // Error
        }
        else {
            PFObject* toolObject = [objects objectAtIndex:0];
            [toolObject setValue:qrCodeString forKey:@"qrCode"];
            [toolObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [lView removeFromSuperview];
                if (succeeded) {
                    // Add check mark
                    [_doneSet addObject:[_selectedObject objectId]];
                    [self.tableView reloadData];
                    
                    // Move to detail view controller
                    AddToolTableViewController* aTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddToolTableViewController"];
                    [aTVC setExam:toolObject];
                    [aTVC setControllerState:ATVC_VIEW_TOOL];
                    [self.navigationController pushViewController:aTVC animated:YES];
                }
                else {
                    // Handle Error
                }
            }];
        }
    }];
}

-(void)HandleAddTool:(NSString*)qrCodeString {
    PFObject* toolObject = [PFObject objectWithClassName:@"Tools"];
    [toolObject setValue:qrCodeString forKey:@"qrCode"];
    [toolObject setValue:[_selectedObject objectForKey:@"toolId"] forKey:@"toolId"];
    AddToolTableViewController* aTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddToolTableViewController"];
    [aTVC setExam:toolObject];
    [aTVC setControllerState:ATVC_ADD_TOOL];
    [self.navigationController pushViewController:aTVC animated:YES];
}

-(void)gotQRCode:(NSString *)qrCodeString {
    if (qrCodeString == nil) {
        // Process Error
        NSLog(@"Canceled pressed");
    }
    else {
//        NSLog(@"Got qrCode: %@", qrCodeString);
        if ([[_selectedObject valueForKey:@"taskType"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [self HandleTagTool:qrCodeString];
        }
        else if ([[_selectedObject valueForKey:@"taskType"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [self HandleAddTool:qrCodeString];
            
        }
        
    }
}

-(void)SaveSucess {
    [_doneSet addObject:_selectedObject];
}


@end
