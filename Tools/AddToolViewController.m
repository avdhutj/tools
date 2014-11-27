//
//  AddToolViewController.m
//  Tools
//
//  Created by Mazin Biviji on 11/25/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "AddToolViewController.h"

@interface AddToolViewController ()

@end

@implementation AddToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //These values should be set in the prepare for segue function from the Scan tab
    PFQuery *query = [PFQuery queryWithClassName:@"SupplierList"];
    self.Supplier = [query getObjectWithId:@"Pj9iWujEKk"];
    
    self.QRCode = @"QRCode_123";
    //Set up for supplier name and address
    self.SupplierNameLbl.text = [self.Supplier objectForKey:@"supplier"];
    self.SupplierAddressLbl.text = [self.Supplier objectForKey:@"address"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddToolBtnClicked:(id)sender {
    NSLog(@"%@",self.Supplier.objectId);
    //Need to perform basic validation to ensure all cells are filled
    PFObject *tool = [PFObject objectWithClassName:@"Tools"];
    tool[@"supplier"] = self.Supplier.objectId;
    tool[@"toolId"] = self.ToolIdTxt.text;
    tool[@"weight"] = [NSNumber numberWithInt:[self.WeightTxt.text integerValue]];
    tool[@"toolDescription"] = self.DescrTxt.text;
    [tool saveInBackground];
    //Need to set up the part number adding thing this might be a little tricky because we will need to tool up the part number that was added and if it isnt there a new part number needs to be created after confirming with the user.
}

- (IBAction)DismissClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
