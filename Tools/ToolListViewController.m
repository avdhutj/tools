//
//  ToolList.m
//  Tools
//
//  Created by Mazin Biviji on 11/21/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "ToolListViewController.h"
#import "ToolDetailViewController.h"
#import "AddToolTableViewController.h"
#import "MapViewController.h"
#import "SupplierListViewController.h"

#import "LoadView.h"

@interface ToolListViewController ()
@property (strong, nonatomic) NSMutableArray* allToolObjects;
@property (strong, nonatomic) NSMutableArray* supplierToolObjects;

@end

@implementation ToolListViewController


//- (id)initWithCoder:(NSCoder *)bCoder {
//    self = [super initWithCoder:bCoder];
//    if (self) {
//        
//        if ([[[PFUser currentUser] objectForKey:@"type"] isEqualToString:@"oem"]) {
//            NSLog(@"here with selected supplier: %@",self.selectedSupplier);
//            self.selectedSupplier = @"All";
//            UIBarButtonItem *barBtnSelectSupplier = [[UIBarButtonItem alloc] initWithTitle:@"Select Supplier" style:UIBarButtonItemStyleDone target:self action:@selector(handleSelectSupplier:)];
//            self.navigationItem.leftBarButtonItem = barBtnSelectSupplier;
//        }
//        self.parseClassName = @"Tools";
//        self.pullToRefreshEnabled = YES;
//        self.paginationEnabled = YES;
//        self.objectsPerPage = 20;
//        
//    }
//    return self;
//}

-(void)viewDidLoad {
    [super viewDidLoad];
    if ([[[PFUser currentUser] objectForKey:@"type"] isEqualToString:@"oem"]) {
        UIBarButtonItem *barBtnSelectSupplier = [[UIBarButtonItem alloc] initWithTitle:@"Select Supplier" style:UIBarButtonItemStyleDone target:self action:@selector(handleSelectSupplier:)];
        self.navigationItem.leftBarButtonItem = barBtnSelectSupplier;
    }
    _allToolObjects = [[NSMutableArray alloc] init];
    _supplierToolObjects = [[NSMutableArray alloc] init];
    _selectedSupplier = nil;
    
    [self loadData];
}

-(void)loadData {
    PFQuery* query = [PFQuery queryWithClassName:@"Tools"];
    if ([[[PFUser currentUser] valueForKey:@"type"] isEqualToString:@"supplier"] ||
        [[[PFUser currentUser] valueForKey:@"type"] isEqualToString:@"review"]) {
        [query whereKey:@"supplier" equalTo:[[PFUser currentUser] valueForKey:@"supplier"]];
    }
    LoadView* lView = [[[NSBundle mainBundle] loadNibNamed:@"LoadView" owner:nil options:nil] lastObject];
    [self.view addSubview:lView];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [lView removeFromSuperview];
        [_allToolObjects addObjectsFromArray:objects];
        [self.tableView reloadData];
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_selectedSupplier)
        return [_supplierToolObjects count];
    else
        return [_allToolObjects count];
}

-(void)UpdateSupplier {
    if (_selectedSupplier) {
        self.navigationItem.leftBarButtonItem.title = @"Clear Supplier";
        [_supplierToolObjects removeAllObjects];
        for (PFObject* object in _allToolObjects) {
            if ([[_selectedSupplier objectId] isEqualToString:[object valueForKey:@"supplier"]]) {
                [_supplierToolObjects addObject:object];
            }
        }
        [self.tableView reloadData];
    }
}

-(void)handleSelectSupplier:(UITapGestureRecognizer *)recognizer {
    if (_selectedSupplier) {
        _selectedSupplier = nil;
        self.navigationItem.leftBarButtonItem.title = @"Select Supplier";
        [self.tableView reloadData];
    }
    else {
        SupplierListViewController* sLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SupplierListViewController"];
        [sLVC setToolListVC:self];
        sLVC.isToolList = TRUE;
        [self.navigationController pushViewController:sLVC animated:YES];
    }
}


/*
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
     //&& ![[[PFUser currentUser] objectForKey:@"type"] isEqualToString:@"oem"]
    if (![self.selectedSupplier isEqualToString:@"All"]) {
        if([[[PFUser currentUser] objectForKey:@"type"] isEqualToString:@"oem"]){
            NSLog(@"In updated supplier: %@",self.selectedSupplier);
            [query whereKey:@"supplier" equalTo:self.selectedSupplier];
        } else {
            [query whereKey:@"supplier" equalTo:[[PFUser currentUser] objectForKey:@"supplier"]];
        }
    }
    
    
    NSLog(@"%@",self.objects);
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    //Supplier for Add tool / detailed tool view controller
//    PFQuery *querySupplier = [PFQuery queryWithClassName:@"SupplierList"];
//    [querySupplier findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
//        self.Supplier = [querySupplier getObjectWithId:@"Pj9iWujEKk"];
//    }];
    
    return query;
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToolCell" forIndexPath:indexPath];
    if (_selectedSupplier) {
        cell.textLabel.text = [[_supplierToolObjects objectAtIndex:indexPath.row] valueForKey:@"toolId"];
    }
    else {
        cell.textLabel.text = [[_allToolObjects objectAtIndex:indexPath.row] valueForKey:@"toolId"];
    }
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"ToolCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
//                                      reuseIdentifier:CellIdentifier];
//    }
    
    cell.textLabel.text = [object objectForKey:@"toolId"];
    
    return cell;
}
*/

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"displayDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject* object;
        if (_selectedSupplier) {
            object = [self.supplierToolObjects objectAtIndex:indexPath.row];
        }
        else {
            object = [self.allToolObjects objectAtIndex:indexPath.row];
        }
        
        AddToolTableViewController *detailViewController = [segue destinationViewController];
        if (_selectedSupplier) {
            detailViewController.Supplier = _selectedSupplier;
        }
        detailViewController.exam = object;
        [detailViewController setControllerState:ATVC_VIEW_TOOL];
    }
    else if ([segue.identifier isEqualToString:@"ToolListMapViewSegue"]) {
        MapViewController* mVC = [segue destinationViewController];
        if (_selectedSupplier) {
            [mVC setControllerState:MV_SHOW_TOOLS_AND_SUPPLIERS];
            [mVC setToolObjects:_supplierToolObjects];
            [mVC setSupplierObjects:[NSArray arrayWithObject:_selectedSupplier]];
        }
        else {
            [mVC setControllerState:MV_SHOW_TOOLS];
            [mVC setToolObjects:_allToolObjects];
        }
    }
}

@end
