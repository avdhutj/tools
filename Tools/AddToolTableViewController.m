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
    /*
    if (self.controllerState == ATVC_ADD_TOOL || self.controllerState == ATVC_EDIT_TOOL) {
        [self setEditing:YES animated:YES];
        //show save tool btn
    } else {
        [self setEditing:NO animated:YES];
    }*/
    
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
        
        
        //View Set up if new tool
        
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
                
                //How to sort this?? tried to also sort this so part numbers are at the bottom so you can add to it using the button
                //self.tableTitles = [[self.items allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                //self.tableTitles = [self.items allKeys];
                
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
        if (self.controllerState != ATVC_VIEW_TOOL && ![sectionTitle  isEqual: @"Supplier"]) {
            TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
            textCell.TextField.text = item;
            if ([sectionTitle isEqualToString:@"Tool Details"]) {
                textCell.imageView.image = self.toolImage;
                if (self.controllerState == ATVC_ADD_TOOL) {[textCell.TextField becomeFirstResponder];}
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
            TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
            textCell.TextField.text = item;
            if (self.controllerState == ATVC_EDIT_TOOL) {[textCell.TextField becomeFirstResponder];}
            [textCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            textCell.initialValue = item;
            textCell.parseKeyIndex = indexPath.row;
            return textCell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellLbl" forIndexPath:indexPath];
            cell.textLabel.text = item;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }
}

#pragma mark - Table Actions
- (IBAction)back:(id)sender {
    //NSLog(@"%@",self.selectedTextFeild.text);
    if (self.controllerState == ATVC_VIEW_TOOL) {
        self.controllerState = ATVC_EDIT_TOOL;
        [self.tableView reloadData];
        self.BackBtn.title = @"Save";
    } else if (self.controllerState != ATVC_VIEW_TOOL) {
        //Save and perform validation
        self.controllerState = ATVC_VIEW_TOOL;
        [self.tableView reloadData];
        self.BackBtn.title = @"Edit";
        
        //Save New Part Numbers
        for (NSString* parts in [self.items objectForKey:@"Part Numbers"]){
            if ([[self.partStausLookUp objectForKey:parts] isEqualToString:@"Add Part No"]) {
                PFObject *newPart = [PFObject objectWithClassName:@"PartNumbers"];
                newPart[@"name"] = parts;
                newPart[@"Flag"] = @"Added Part No";
                newPart[@"status"] = @"TBD";
                [newPart saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded){
                        [self.partNumbers addObject:newPart.objectId];
                        NSLog(@"%@",self.partNumbers);
                    } else {
                        NSLog(@"%@", [error userInfo]);
                    }
                 }];
            }
        }
        
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
    
    if ([[updateDict objectForKey:@"isUpdated"] isEqualToString:@"Updated"]){
        
        //Add UpdateArray to the EditViewUpdates Array
        if ([[updateDict objectForKey:@"ParseClass"] isEqualToString:@"PartNumbers"]) {
            //Part Numbers
            //updateArray format:(NSString)isUpdated (NSString)ParseClass (NSString)PraseKey (NSString)UpdatedValue (NSString)UpdateObjectId (int)UpdateIndexNo (NSString)UpdatedStatus
            if([[updateDict objectForKey:@"UpdateObjectId"] isEqualToString:@"new"]){
                //New Part Numbers - add to PartNumbers (with new flag) and to tool
                NSMutableArray *PartNos = [NSMutableArray arrayWithArray:[self.items objectForKey:@"Part Numbers"]];
                [PartNos setObject:[updateDict objectForKey:@"UpdatedValue"] atIndexedSubscript:[[updateDict objectForKey:@"UpdateIndexNo"] integerValue]];
                [self.items setObject:PartNos forKey:@"Part Numbers"];
                
                [self.partStausLookUp setObject:@"Add Part No" forKey:[updateDict objectForKey:@"UpdatedValue"]];
                
            } if ([[updateDict objectForKey:@"UpdateObjectId"] isEqualToString:@"toReview"]) {
                //To Review Part Numbers - need to update
                
            } else {
                //Add exsisting part number to tool
                NSMutableArray *PartNos = [NSMutableArray arrayWithArray:[self.items objectForKey:@"Part Numbers"]];
                [PartNos setObject:[updateDict objectForKey:@"UpdatedValue"] atIndexedSubscript:[[updateDict objectForKey:@"UpdateIndexNo"] integerValue]];
                [self.items setObject:PartNos forKey:@"Part Numbers"];
                
                //Updated PartNumbers with ObjectID
                [self.partStausLookUp setObject:[updateDict objectForKey:@"UpdatedStatus"]forKey:[updateDict objectForKey:@"UpdatedValue"]];
                [self.partNumbers addObject:[updateDict objectForKey:@"UpdateObjectId"]];
                
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

/*
#pragma mark - Edit Mode

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    
    NSString *sectionTitle = [self.tableTitles objectAtIndex:indexPath.section];
    
    if ([sectionTitle isEqualToString:@"Part Numbers"]) {
        
        return YES;
    }
    
    return NO;
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
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}*/

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
        map.tool = self.exam;
        map.supplier = self.Supplier;
    }
}
@end
