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
#import "ToolTypeCell.h"
#import "APPViewController.h"

@interface AddToolTableViewController ()

@property NSArray *addToolTitles;

@end

@implementation AddToolTableViewController

- (void)SetUpNotificationCenterPartNumber:(UITableViewCell *)PartNo {
    
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

    if (self.controllerState == ATVC_ADD_TOOL || self.controllerState == ATVC_EDIT_TOOL) {
        [self setEditing:YES animated:NO];
    } else {
        [self setEditing:NO animated:NO];
    }
    
    //Default Images
    self.cameraImage = [UIImage imageNamed:@"CameraImg"];
    self.cameraSelectedImage = [UIImage imageNamed:@"CameraSelectedImg"];
    self.PhoneImage = [UIImage imageNamed:@"phone"];
    self.PhoneSelectedImage = [UIImage imageNamed:@"phoneSelected"];
    self.toolImage = [UIImage imageNamed:@"UserImg"];
    
    if (self.controllerState == ATVC_ADD_TOOL) {
        
        NSDictionary *dict =  @{@"Supplier" : @[@"Supplier", @"Supplier Address",@"Phone Number"],
                                @"Tool Details" : @[@"Tool ID", @"Weight", @"Tool Type",@"Tool Description"],
                                @"Part Numbers" : @[@"New part number"]};
        
        self.partStausLookUp = [NSMutableDictionary dictionaryWithObject:@"Status" forKey:@"Part Number"];
        self.items = [NSMutableDictionary dictionaryWithDictionary:dict];
        self.tableTitles = [[NSMutableArray alloc] initWithCapacity:[dict count]];
        [self.tableTitles addObject:@"Tool Details"];
        [self.tableTitles addObject:@"Part Numbers"];
        [self.tableTitles addObject:@"Supplier"];
        
        self.AddedPartNumbers = [NSMutableArray arrayWithArray:@[@"new"]];
        
        [self.tableView reloadData];
        
    } else if (self.controllerState == ATVC_EDIT_TOOL || self.controllerState == ATVC_VIEW_TOOL) {
        
        [self LoadExsistingToolDetails];

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

-(void)handlePhoneCall:(UITapGestureRecognizer *)recognizer{
    
    NSString *phoneNumber = [@"tel://" stringByAppendingString:[self.Supplier objectForKey:@"phoneNumber"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
}

-(void)handleTap:(UITapGestureRecognizer *)recognizer {
 
    APPViewController* cameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TakePhotoViewController"];
    if (self.controllerState == ATVC_ADD_TOOL) {
        PFObject *tool = [PFObject objectWithClassName:@"Tools"];
        self.exam = tool;
        self.controllerState = ATVC_EDIT_TOOL;
    }
    cameraVC.tool = self.exam;
    [self.navigationController pushViewController:cameraVC animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    
    NSString *sectionTitle = [self.tableTitles objectAtIndex:indexPath.section];
    NSArray *sectionitems = [self.items objectForKey:sectionTitle];
    NSString*item = [sectionitems objectAtIndex:indexPath.row];
    
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
            
            if (indexPath.row == [self.AddedPartNumbers count] && ![item isEqualToString:@"New part number"]) {
                //Add part no
                NSLog(@"In Add Part No with Parts: %@ item: %@ index.row: %i items: %@",self.AddedPartNumbers, item, indexPath.row, self.items);
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
        
        if (self.controllerState == ATVC_ADD_TOOL && indexPath.section == 0) {
            TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
            textCell.TextField.text = item;
            if ([sectionTitle isEqualToString:@"Tool Details"]) {
                textCell.imageView.image = self.cameraImage;
                UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
                textCell.TextField.leftView = paddingView;
                textCell.TextField.leftViewMode = UITextFieldViewModeAlways;
                textCell.initialValue = item;
                textCell.parseKeyIndex = indexPath.row;
            }
            [textCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self SetUpNotificationCenterPartNumber:textCell];
            return textCell;
        }  else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellToolId" forIndexPath:indexPath];
            cell.textLabel.text = item;
            if ([sectionTitle isEqualToString:@"Tool Details"]){
                cell.imageView.image = self.cameraImage;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                cell.imageView.userInteractionEnabled = YES;
                [cell.imageView addGestureRecognizer:tap];
                cell.detailTextLabel.text = self.toolStatus;
            } else {
                //phone call image
                cell.imageView.image = self.PhoneImage;
                UITapGestureRecognizer *call = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePhoneCall:)];
                cell.imageView.userInteractionEnabled = YES;
                [cell.imageView addGestureRecognizer:call];
                cell.detailTextLabel.text = @"";
            };
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        
    } else {
        if (self.controllerState != ATVC_VIEW_TOOL && ![sectionTitle  isEqual: @"Supplier"]) {
            if(indexPath.section == 0 && indexPath.row ==1) {
                //Weight in Edit Mode
                TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"NumberTextCell" forIndexPath:indexPath];
                if (self.controllerState == ATVC_ADD_TOOL) {
                    textCell.TextField.placeholder = @"Weight";
                }
                textCell.TextField.text = item;
                [textCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                textCell.initialValue = item;
                //WHY IS THIS NOT WORKING??
                textCell.TextField.keyboardType = UIKeyboardTypeNamePhonePad;
                //
                textCell.parseKeyIndex = indexPath.row;
                [self SetUpNotificationCenterPartNumber:textCell];
                return textCell;
            } else if(indexPath.section == 0 && indexPath.row ==2) {
                //Tool Type in Edit Mode
                ToolTypeCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"ToolTypeInput" forIndexPath:indexPath];
                if ([item isEqualToString:@"Stamping die"]) {
                    textCell.ToolTypeSegControl.selectedSegmentIndex = 0;
                } else if ([item isEqualToString:@"Injection mold"]) {
                    textCell.ToolTypeSegControl.selectedSegmentIndex = 1;
                } else if ([item isEqualToString:@"Check fixture"]){
                    textCell.ToolTypeSegControl.selectedSegmentIndex = 2;
                } else if ([item isEqualToString:@"Gauge"]) {
                    textCell.ToolTypeSegControl.selectedSegmentIndex = 3;
                } else {
                    textCell.ToolTypeSegControl.selectedSegmentIndex = 4;
                }
                [textCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                textCell.initialValue = item;
                textCell.parseKeyIndex = indexPath.row;
                [self SetUpNotificationCenterPartNumber:textCell];
                return textCell;
            } else {
                //Other
                TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
                textCell.TextField.text = item;
                //textCell.TextField.textColor = [UIColor grayColor];
                [textCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                textCell.initialValue = item;
                textCell.parseKeyIndex = indexPath.row;
                [self SetUpNotificationCenterPartNumber:textCell];
                return textCell;
            }
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellLbl" forIndexPath:indexPath];
            cell.textLabel.text = item;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }
}
- (IBAction)flagValueChanged:(id)sender {
    
    
}

- (void)LoadExsistingToolDetails {
    //View Set up if exsisting tool
    NSArray *partIDs = [self.exam objectForKey:@"part"];
    self.partNumbers = [NSMutableArray new];
    self.partStausLookUp = [[NSMutableDictionary alloc] init];
    self.toolStatus = [NSString stringWithFormat:@"TBD"];
    __block int obsCount = 0;
    
    //Tool image set up
    PFFile* img = [self.exam objectForKey:@"imageFile"];
    UIImage* image = [UIImage imageWithData:[img getData]];
    CGImageRef cgref = [image CGImage];
    CIImage *cim = [image CIImage];
    if (cim == nil && cgref == NULL) {
        self.cameraImage = [UIImage imageNamed:@"CameraImg"];
    } else {
        self.cameraImage = image;
    }
    
    //Parts Query
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
            
            //TODO: Mazin check this if this is true
            NSDictionary *dict;
            if (self.Supplier) {
                dict =  @{@"Supplier" : @[[self.Supplier objectForKey:@"supplier"], [self.Supplier objectForKey:@"address"], [self.Supplier objectForKey:@"phoneNumber"]],
                          @"Tool Details" : @[[self.exam objectForKey:@"toolId"], [NSString stringWithFormat:@"%@",[self.exam objectForKey:@"weight"]], [self.exam objectForKey:@"toolType"],[self.exam objectForKey:@"toolDescription"]]};
            }
            else {
                dict =  @{@"Tool Details" : @[[self.exam objectForKey:@"toolId"], [NSString stringWithFormat:@"%@",[self.exam objectForKey:@"weight"]], [self.exam objectForKey:@"toolType"],[self.exam objectForKey:@"toolDescription"]]};
            }
            
            self.ToolFlagSegControl.selectedSegmentIndex = [[self.exam objectForKey:@"flag"] integerValue];
            NSLog(@"select: %i",self.ToolFlagSegControl.selectedSegmentIndex);
            
            self.items = [NSMutableDictionary dictionaryWithDictionary:dict];
            [self.items setObject:self.partNumbers forKey:@"Part Numbers"];
            self.AddedPartNumbers = [NSMutableArray arrayWithArray:partIDs];
            
            self.tableTitles = [[NSMutableArray alloc] initWithCapacity:[dict count]];
            [self.tableTitles addObject:@"Tool Details"];
            [self.tableTitles addObject:@"Part Numbers"];
            [self.tableTitles addObject:@"Supplier"];
            
            
            
            [self.tableView reloadData];
            
            
        } else {
            NSLog(@"%@", [error userInfo]);
        }
    }];
    NSString* supplierId = [self.exam valueForKey:@"supplier"];
    if (supplierId) {
        PFObject* supplier = [PFObject objectWithoutDataWithClassName:@"SupplierList" objectId:supplierId];
        [supplier fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                self.Supplier = supplier;
                NSArray* sup = [NSArray arrayWithObjects:[self.Supplier objectForKey:@"supplier"], [self.Supplier objectForKey:@"address"], [self.Supplier objectForKey:@"phoneNumber"], nil];
                [self.items setObject:sup forKey:@"Supplier"];
                [self.tableView reloadData];
            }
            
        }];
    }
    PFObject* supplier = [PFObject objectWithoutDataWithClassName:@"SupplierList" objectId:supplierId];
    [supplier fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            self.Supplier = supplier;
            NSArray* sup = [NSArray arrayWithObjects:[self.Supplier objectForKey:@"supplier"], [self.Supplier objectForKey:@"address"], [self.Supplier objectForKey:@"phoneNumber"], nil];
            [self.items setObject:sup forKey:@"Supplier"];
            [self.tableView reloadData];
        }
        
    }];

}

#pragma mark - Table Actions

-(void)addPartNumberRow{
    
    [self.AddedPartNumbers addObject:@"new"];
    NSString *newPart = @"New part number";
    NSMutableArray* partsMutable = [[self.items objectForKey:@"Part Numbers"] mutableCopy];
    [partsMutable addObject:newPart];
    [self.items setObject:partsMutable forKey:@"Part Numbers"];
    [self.partStausLookUp addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"-" forKey:newPart]];
    //[self.tableView reloadData];
    
}

-(void)saveToolId {
    
    if (self.controllerState == ATVC_ADD_TOOL) {
        PFObject *tool = [PFObject objectWithClassName:@"Tools"];
        self.exam = tool;

    }
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    [formater setNumberStyle:NSNumberFormatterNoStyle];
    NSArray *toolDetails = [self.items objectForKey:@"Tool Details"];
    self.exam[@"toolId"] = toolDetails[0];
    self.exam[@"weight"] = [formater numberFromString:toolDetails[1]];
    self.exam[@"toolType"] = toolDetails[2];
    self.exam[@"toolDescription"] = toolDetails[3];
    self.exam[@"part"] = self.AddedPartNumbers;
    self.exam[@"flag"] = [NSNumber numberWithInt:self.ToolFlagSegControl.selectedSegmentIndex];
    [self.exam saveInBackground];
    [self.tableView reloadData];
    
    if (_inventoryViewController) {
        [_inventoryViewController setAddedTool:self.exam];
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"%@",self.exam);
}

- (IBAction)back:(id)sender {
    
    if (self.controllerState == ATVC_VIEW_TOOL) {
        self.controllerState = ATVC_EDIT_TOOL;
        [self.tableView setEditing:YES animated:YES];
        self.BackBtn.title = @"Save";
        [self addPartNumberRow];
        [self.tableView reloadData];
        
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
            
            for (NSString* parts in [self.items objectForKey:@"Part Numbers"]) {
                
                if ([parts isEqualToString:@"New part number"]) {
                    
                    [partNumbers removeObjectAtIndex:partsCounter];
                    [self.AddedPartNumbers removeObjectAtIndex:partsCounter];
                }
                
                partsCounter++;

            }

            [self.items setObject:partNumbers forKey:@"Part Numbers"];
            
            //Save New Part Numbers
            int CountParts = 0;
            NSMutableArray *newPartNumbers = [NSMutableArray new];
            NSMutableArray *ExsistingPartNumbers  = [NSMutableArray new];
            
            for (NSString* parts in [self.items objectForKey:@"Part Numbers"]){
                if ([[self.AddedPartNumbers objectAtIndex:CountParts] isEqualToString:@"new"]) {
                    [newPartNumbers addObject:parts];
                    
                } else {
                    [ExsistingPartNumbers addObject:[self.AddedPartNumbers objectAtIndex:CountParts]];
                    
                }
                CountParts++;
            }
            
            if ([newPartNumbers count]>0) {
                
                __block int count = 0;
                __block int valueIsUpdated = 0;
                
                for (NSString* parts in newPartNumbers){
                        PFObject *newPart = [PFObject objectWithClassName:@"PartNumbers"];
                        newPart[@"name"] = parts;
                        newPart[@"Flag"] = @"Added Part No";
                        newPart[@"status"] = @"TBD";
                        [newPart saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if(succeeded){
                                valueIsUpdated = count;
                                [newPartNumbers setObject:newPart.objectId atIndexedSubscript:count];
                                if (count == [newPartNumbers count]) {
                                    //Save changes to tool Id
                                    self.AddedPartNumbers = [[newPartNumbers arrayByAddingObjectsFromArray:ExsistingPartNumbers] mutableCopy];
                                    [self saveToolId];
                                }
                            } else {
                                NSLog(@"%@", [error userInfo]);
                            }
                        }];
                    
                    if (count == [[self.items objectForKey:@"Part Numbers"] count] && valueIsUpdated == count) {
                        NSLog(@"Save Tool - new count: %i",count);
                        //Save changes to tool Id
                        self.AddedPartNumbers = ExsistingPartNumbers;
                        [self saveToolId];
                    }
                    count++;
                }
            } else {
                [self saveToolId];
            }
            
            [self.tableView setEditing:NO animated:YES];
            
        }
        
        [self.tableView reloadData];
    }
}

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
                [self.AddedPartNumbers setObject:[updateDict objectForKey:@"UpdateObjectId"] atIndexedSubscript:[[updateDict objectForKey:@"UpdateIndexNo"] integerValue]];
                
            }
            
        } else if ([[updateDict objectForKey:@"ParseClass"] isEqualToString:@"Tools"]) {
            //NSLog(@"In tools index: %i updated value: %@",[[updateDict objectForKey:@"ParseKey"] integerValue], [updateDict objectForKey:@"UpdatedValue"]);
            //Tools
            //updateArray format:(NSString)isUpdated (NSString)ParseClass (int)PraseKey (NSString)UpdatedValue
            //@"Tool Details" : @[@"Tool ID", @"Weight", @"Tool Type",@"Tool Description"],
            NSMutableArray* tool =[[self.items objectForKey:@"Tool Details"] mutableCopy];
            [tool setObject:[updateDict objectForKey:@"UpdatedValue"] atIndexedSubscript:[[updateDict objectForKey:@"ParseKey"] integerValue]];
            [self.items setObject:tool forKey:@"Tool Details"];
            
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
        
        if ([[self.items objectForKey:@"Part Numbers"] count] > 2) {
            return YES;
        }
        
    }
    
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if ([[self.tableTitles objectAtIndex:indexPath.section] isEqualToString:@"Part Numbers"]) {
            NSMutableArray *parts = [NSMutableArray arrayWithArray:[self.items objectForKey:@"Part Numbers"]];
            [parts removeObjectAtIndex:indexPath.row];
            [self.AddedPartNumbers removeObjectAtIndex:indexPath.row];
            [self.items setObject:parts forKey:@"Part Numbers"];
            [self.tableView reloadData];
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
