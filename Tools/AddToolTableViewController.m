//
//  AddToolTableViewController.m
//  Tools
//
//  Created by Mazin Biviji on 11/27/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//
//Updates: to filter on tools and part numbers by OEM -> [innerQuery whereKeyExists:@"image"]; from https://parse.com/docs/ios_guide#queries/iOS

#import "AddToolTableViewController.h"
#import "MapViewController.h"
#import "PartNoCell.h"
#import "TextFieldCell.h"

@interface AddToolTableViewController ()

@property NSArray *addToolTitles;

@end

@implementation AddToolTableViewController

- (void)SetUpNotificationCenterPartNumber:(PartNoCell *)PartNo {
    
    if (self.controllerState != ATVC_VIEW_TOOL) {
        self.BackBtn.title = @"Save";
        //Notificaiton Center Setup
        NSString *notifcaitonName = @"PartNoLookUpComplete";
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(TextFieldChangedNotification:)
                                                     name:notifcaitonName
                                                   object:PartNo];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Uncomment to add + button to right navigationbar btn
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPartNumberRow:)];

    if (self.controllerState == ATVC_ADD_TOOL || self.controllerState == ATVC_EDIT_TOOL) {
        [self setEditing:YES animated:NO];
        //show save tool btn
        //self.BackBtn.title = @"Save";
    } else {
        [self setEditing:NO animated:NO];
    }
    
    if (self.controllerState == ATVC_ADD_TOOL) {
        
        NSDictionary *dict =  @{@"Supplier" : @[@"Supplier", @"Supplier Address"],
                                @"Tool Details" : @[@"Tool ID", @"Weight", @"Tool Type",@"Tool Description"],
                                @"Part Numbers" : @[@"Part Number"]};
        
        self.partStausLookUp = [NSMutableDictionary dictionaryWithObject:@"Status" forKey:@"Part Number"];
        
        self.items = [NSMutableDictionary dictionaryWithDictionary:dict];
        //How to sort this?? tried to also sort this so part numbers are at the bottom so you can add to it using the button
        //self.tableTitles = [[self.items allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//        self.tableTitles = [self.items allKeys];
        self.tableTitles = [[NSMutableArray alloc] initWithCapacity:[dict count]];
        [self.tableTitles addObject:@"Tool Details"];
        [self.tableTitles addObject:@"Part Numbers"];
        [self.tableTitles addObject:@"Supplier"];
        
        [self.tableView reloadData];
        
    } else if (self.controllerState == ATVC_EDIT_TOOL || self.controllerState == ATVC_VIEW_TOOL) {
        
        //View Set up if exsisting tool
        NSArray *partIDs = [self.exam objectForKey:@"part"];
        self.partNumbers = [NSMutableArray new];
        self.partStausLookUp = [[NSMutableDictionary alloc] init];
        self.toolStatus = [NSString stringWithFormat:@"TBD"];
        __block int obsCount = 0;
        self.queryParts = [PFQuery queryWithClassName:@"PartNumbers"];
        
        [self.queryParts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if(!error) {
                for (NSString* part in partIDs){
                    PFObject* partNo = [self.queryParts getObjectWithId:part];
                    NSString *status = [partNo objectForKey:@"status"];
                    [self.partNumbers addObject:[partNo objectForKey:@"name"]];
                    [self.partStausLookUp setObject:status forKey:[partNo objectForKey:@"name"]];
                    if([status isEqual:@"Active"]){
                        self.toolStatus = status;
                    } else if ([status isEqual:@"Obsolete"]){
                        obsCount ++;
                    }
                };
                
                if ([partIDs count]==obsCount) {
                    self.toolStatus = @"Obsolete";
                }
                
                //Set Up for the  cells in the table
                
                NSDictionary *dict =  @{@"Supplier" : @[[self.Supplier objectForKey:@"supplier"], [self.Supplier objectForKey:@"address"]],
                                        @"Tool Details" : @[[self.exam objectForKey:@"toolId"], [NSString stringWithFormat: @"%i lbs",[[self.exam objectForKey:@"weight"]integerValue]], [self.exam objectForKey:@"toolType"],@"toolDescription"]};
                
                self.items = [NSMutableDictionary dictionaryWithDictionary:dict];
                [self.items setObject:self.partNumbers forKey:@"Part Numbers"];
                self.AddedPartNumbers = [NSMutableArray arrayWithArray:self.partNumbers];
                
                self.tableTitles = [[NSMutableArray alloc] initWithCapacity:[dict count]];
                [self.tableTitles addObject:@"Tool Details"];
                [self.tableTitles addObject:@"Part Numbers"];
                [self.tableTitles addObject:@"Supplier"];
                
                [self.tableView reloadData];
                
            } else {
                NSLog(@"%@", [error userInfo]);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.tableTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.tableTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSString *sectionTitle = [self.tableTitles objectAtIndex:section];
    NSArray *sectionItems = [self.items objectForKey:sectionTitle];
    return [sectionItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Get tool image from parse
    self.toolImage = [UIImage imageNamed:@"UserImg"];
    
    // Configure the cell...
    
    NSString *sectionTitle = [self.tableTitles objectAtIndex:indexPath.section];
    NSArray *sectionitems = [self.items objectForKey:sectionTitle];
    NSString *item = [sectionitems objectAtIndex:indexPath.row];
    
    //enable text feild
    
    if ([sectionTitle isEqualToString:@"Part Numbers"]) {
        
        if (self.controllerState != ATVC_VIEW_TOOL) {
            PartNoCell *PartTextCell = [tableView dequeueReusableCellWithIdentifier:@"PartNoTextCell" forIndexPath:indexPath];
            PartTextCell.TextField.text = item;
            if ([self.partStausLookUp count] > 0) {
                PartTextCell.PartStatusLbl.text = [self.partStausLookUp objectForKey:item];
            }
            [PartTextCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            PartTextCell.initialValue = item;
            [self SetUpNotificationCenterPartNumber:PartTextCell];
            PartTextCell.ArrayIndex = indexPath.row;
            
            if (indexPath.row == [self.AddedPartNumbers count]) {
                //Add part no
                [self addPartNumberRow];
            }
            
            if (indexPath.row == [[self.items objectForKey:@"Part Numbers"] count] - 1) {
                PartTextCell.TextField.textColor =[UIColor lightGrayColor];
            }
            
            return PartTextCell;

        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellDetail" forIndexPath:indexPath];
        cell.textLabel.text = item;
        if ([self.partStausLookUp count] > 0) {
            cell.detailTextLabel.text = [self.partStausLookUp objectForKey:item];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    } else if (indexPath.row==0) {
        
        if (self.controllerState == ATVC_ADD_TOOL && indexPath.section == 1) {
            TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
            textCell.TextField.text = item;
            if ([sectionTitle isEqualToString:@"Tool Details"]) {
                textCell.imageView.image = self.toolImage;
                //if (self.controllerState == ATVC_ADD_TOOL) {[textCell.TextField becomeFirstResponder];}
                UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
                textCell.TextField.leftView = paddingView;
                textCell.TextField.leftViewMode = UITextFieldViewModeAlways;
                textCell.initialValue = item;
                textCell.parseKeyIndex = indexPath.row;
            }
            [textCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return textCell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellToolId" forIndexPath:indexPath];
            cell.textLabel.text = item;
            if ([sectionTitle isEqualToString:@"Tool Details"]){
                cell.imageView.image = self.toolImage;
                cell.detailTextLabel.text = self.toolStatus;
            } else {cell.detailTextLabel.text = @"";};
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        
    } else {
        if (self.controllerState != ATVC_VIEW_TOOL && ![sectionTitle  isEqual: @"Supplier"]) {
            if(indexPath.section == 0 && indexPath.row ==1) {
                //Weight in Edit Mode
                TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
                textCell.TextField.text = item;
                [textCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                textCell.initialValue = item;
                textCell.parseKeyIndex = indexPath.row;
                return textCell;
            } else if(indexPath.section == 0 && indexPath.row ==2) {
                //Tool Type in Edit Mode
                TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
                textCell.TextField.text = item;
                [textCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                textCell.initialValue = item;
                textCell.parseKeyIndex = indexPath.row;
                return textCell;
            } else {
                //Other - text in dark grey
                TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
                textCell.TextField.text = item;
                textCell.TextField.textColor = [UIColor grayColor];
                [textCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                textCell.initialValue = item;
                textCell.parseKeyIndex = indexPath.row;
                return textCell;
            }
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellLbl" forIndexPath:indexPath];
            
            if (indexPath.section == 0 && indexPath.row ==3) {
                cell.textLabel.textColor = [UIColor grayColor];
            }
            cell.textLabel.text = item;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }
}

#pragma mark - Table Actions

-(void)addPartNumberRow{

    [self.AddedPartNumbers addObject:@"new"];
    NSString *newPart = @"New part number";
    NSMutableArray* partsMutable = [self.items objectForKey:@"Part Numbers"];
    [partsMutable addObject:newPart];
    [self.items setObject:partsMutable forKey:@"Part Numbers"];
    [self.partStausLookUp addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"-" forKey:newPart]];
    [self.tableView reloadData];
    
}

-(void)saveToolId {
    
    if (self.controllerState == ATVC_ADD_TOOL) {
        PFObject *tool = [PFObject objectWithClassName:@"Tools"];
        self.exam = tool;

    }
    
    NSArray *toolDetails = [self.items objectForKey:@"Tool Details"];
    self.exam[@"toolId"] = toolDetails[0];
    self.exam[@"weight"] = toolDetails[1];
    self.exam[@"toolType"] = toolDetails[2];
    self.exam[@"toolDescription"] = toolDetails[3];
    //this or part numbers?
    self.exam[@"part"] = self.AddedPartNumbers;
    NSLog(@"%@",self.exam);
    [self.exam saveInBackground];
    [self.tableView reloadData];
}

- (IBAction)back:(id)sender {
    //NSLog(@"%@",self.selectedTextFeild.text);
    if (self.controllerState == ATVC_VIEW_TOOL) {
        self.controllerState = ATVC_EDIT_TOOL;
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        self.BackBtn.title = @"Save";
        [self addPartNumberRow];
        
    } else if (self.controllerState != ATVC_VIEW_TOOL) {
        
        if ([self.BackBtn.title isEqualToString:@"Edit"]) {
            [self.tableView setEditing:YES animated:YES];
        }  else {
            //Save and perform validation
            self.controllerState = ATVC_VIEW_TOOL;
            //[self.tableView reloadData];
            self.BackBtn.title = @"Edit";
            
            //Dont add part number if New part number
            int partsCounter = 0;
            
            NSMutableArray *partNumbers = [NSMutableArray arrayWithArray:[self.items objectForKey:@"Part Numbers"]];
            
            for (NSString* parts in partNumbers) {
                
                if ([parts isEqualToString:@"New part number"]) {
                    
                    [partNumbers removeObjectAtIndex:partsCounter];
                    [self.AddedPartNumbers removeObjectAtIndex:partsCounter];
                    NSLog(@"%@",self.AddedPartNumbers);
                }
                
                [self.items setObject:partNumbers forKey:@"Part Numbers"];
                partsCounter++;
            }
            
            //Save New Part Numbers
            __block int count = 0;
            
            for (NSString* parts in [self.items objectForKey:@"Part Numbers"]){
                if ([self.AddedPartNumbers[count] isEqualToString:@"new"]) {
                    PFObject *newPart = [PFObject objectWithClassName:@"PartNumbers"];
                    newPart[@"name"] = parts;
                    newPart[@"Flag"] = @"Added Part No";
                    newPart[@"status"] = @"TBD";
                    [newPart saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded){
                            [self.AddedPartNumbers addObject:newPart.objectId];
                            //NSLog(@"%@",self.partNumbers);
                            count++;

                            if (count == [[self.items objectForKey:@"Part Numbers"] count]) {
                                NSLog(@"Save Tool - new count: %i",count);
                                //Save changes to tool Id
                                [self saveToolId];
                            }
                        } else {
                            NSLog(@"%@", [error userInfo]);
                        }
                    }];
                }
                
            }
            
            [self.tableView setEditing:NO animated:YES];
            
        }
        
        [self.tableView reloadData];
    }
}

    /*
     //Need to perform basic validation to ensure all cells are filled
     PFObject *tool = [PFObject objectWithClassName:@"Tools"];
     tool[@"supplier"] = self.;
     tool[@"toolId"] = self.ToolIdTxt.text;
     tool[@"weight"] = [NSNumber numberWithInt:[self.WeightTxt.text integerValue]];
     tool[@"toolDescription"] = self.DescrTxt.text;
     [tool saveInBackground];
     //Need to set up the part number adding thing this might be a little tricky because we will need to tool up the part number that was added and if it isnt there a new part number needs to be created after confirming with the user.*/

-(void)TextFieldChangedNotification:(NSNotification *) notification {
    
    NSDictionary *updateDict  = [[notification userInfo] objectForKey:@"updateArray"];
    
    if ([[updateDict objectForKey:@"isUpdated"] isEqualToString:@"UpdatedAdd"]) {
        [self addPartNumberRow];
        [updateDict setValue:@"Updated" forKey:@"isUpdated"];
    }
    
    if ([[updateDict objectForKey:@"isUpdated"] isEqualToString:@"Updated"]){
        
        //Add UpdateArray to the EditViewUpdates Array
        if ([[updateDict objectForKey:@"ParseClass"] isEqualToString:@"PartNumbers"]) {
            //Part Numbers
            //updateArray format:(NSString)isUpdated (NSString)ParseClass (NSString)PraseKey (NSString)UpdatedValue (NSString)UpdateObjectId (int)UpdateIndexNo (NSString)UpdatedStatus
            if([[updateDict objectForKey:@"UpdateObjectId"] isEqualToString:@"new"]){
                //New Part Numbers - add to PartNumbers (with new flag) and to tool
                NSMutableArray *PartNos = [NSMutableArray arrayWithArray:[self.items objectForKey:@"Part Numbers"]];
                [PartNos setObject:[updateDict objectForKey:@"UpdatedValue"] atIndexedSubscript:[[updateDict  objectForKey:@"UpdateIndexNo"] integerValue]];
                [self.items setObject:PartNos forKey:@"Part Numbers"];
                [self.partStausLookUp setObject:@"Add Part No" forKey:[updateDict objectForKey:@"UpdatedValue"]];
                [self.AddedPartNumbers setObject:[updateDict objectForKey:@"UpdateObjectId"] atIndexedSubscript:[[updateDict objectForKey:@"UpdateIndexNo"] integerValue]];
                
            } if ([[updateDict objectForKey:@"UpdateObjectId"] isEqualToString:@"toReview"]) {
                //To Review Part Numbers - need to update
                
            } else {
                //Add exsisting part number to tool
                NSMutableArray *PartNos = [NSMutableArray arrayWithArray:[self.items objectForKey:@"Part Numbers"]];
                [PartNos setObject:[updateDict objectForKey:@"UpdatedValue"] atIndexedSubscript:[[updateDict objectForKey:@"UpdateIndexNo"] integerValue]];
                [self.items setObject:PartNos forKey:@"Part Numbers"];
                
                //Updated PartNumbers with ObjectID
                [self.partStausLookUp setObject:[updateDict objectForKey:@"UpdatedStatus"]forKey:[updateDict objectForKey:@"UpdatedValue"]];
                [self.AddedPartNumbers addObject:[updateDict objectForKey:@"UpdateObjectId"]];
                
            }
            
        } else if ([[updateDict objectForKey:@"ParseClass"] isEqualToString:@"Tools"]) {
            //Tools
            //updateArray format:(NSString)isUpdated (NSString)ParseClass (int)PraseKey (NSString)UpdatedValue
            //@"Tool Details" : @[@"Tool ID", @"Weight", @"Tool Type",@"Tool Description"],
            NSMutableArray* tool =[self.items objectForKey:@"Tool Details"];
            [tool setObject:[updateDict objectForKey:@""] atIndexedSubscript:[[updateDict objectForKey:@"ParseKey"] integerValue]];
            
            
        } else {
            
        }
        
    }
    

    [self.tableView reloadData];
}

/*

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   NSLog(@"Row Selected: %@",indexPath);
    PartNoCell * cell = (PartNoCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.selectedTextFeild = cell.TextField; // cell.tf is a UITextField property defined on MyCell
    [self.selectedTextFeild becomeFirstResponder];
}*/

#pragma mark - Story Board


#pragma mark - Edit Mode

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    
    NSString *sectionTitle = [self.tableTitles objectAtIndex:indexPath.section];
    
    if ([sectionTitle isEqualToString:@"Part Numbers"]) {
        
        if ([[self.items objectForKey:@"Part Numbers"] count] > 2 && indexPath.row > 0) {
            return YES;
        }
        
    }
    
    return NO;
}

/*
//Update setEditing to add a button
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing) {
        // Add the + button
        UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
        self.navigationItem.leftBarButtonItem = addBtn;
    } else {
        // remove the + button
        self.navigationItem.leftBarButtonItem = nil;
    }
}*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if ([[self.tableTitles objectAtIndex:indexPath.section] isEqualToString:@"Part Numbers"]) {
            NSMutableArray *parts = [NSMutableArray arrayWithArray:[self.items objectForKey:@"Part Numbers"]];
            [parts removeObjectAtIndex:indexPath.row];
            [self.AddedPartNumbers removeObjectAtIndex:indexPath.row];
            [self.items setObject:parts forKey:@"Part Numbers"];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle = [self.tableTitles objectAtIndex:indexPath.section];
    
    if ([sectionTitle isEqualToString:@"Part Numbers"]) {
        
        return YES;
    }
    
    return NO;
}*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    

    NSLog(@"move from:%ld to:%ld", (long)fromIndexPath.row, (long)toIndexPath.row);
    // fetch the object at the row being moved
    NSString *r = [self.tableTitles objectAtIndex:fromIndexPath.row];
    NSMutableArray *titiles = [NSMutableArray arrayWithArray:self.tableTitles];
    
    // remove the original from the data structure
    [titiles removeObjectAtIndex:fromIndexPath.row];
    
    // insert the object at the target row
    [titiles insertObject:r atIndex:toIndexPath.row];
    NSLog(@"result of move :\n%@", self.title);
}*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MapView"]) {
        MapViewController *map = [segue destinationViewController];
        [map setControllerState:MV_SHOW_TOOLS];
        [map setToolObjects:[NSArray arrayWithObject:self.exam]];
        //map.supplier = self.Supplier;
    }
}
@end
