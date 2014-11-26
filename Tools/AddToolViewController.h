//
//  AddToolViewController.h
//  Tools
//
//  Created by Mazin Biviji on 11/25/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddToolViewController : UIViewController

//Values set in the prepare to Segue function
//@property* SupplierName;
@property (strong, nonatomic) PFObject *Supplier;
@property NSString* QRCode;


//Values to be filled in from the Add tool View Controller
@property (weak, nonatomic) IBOutlet UILabel *SupplierNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *SupplierAddressLbl;
@property (weak, nonatomic) IBOutlet UITextField *ToolIdTxt;
@property (weak, nonatomic) IBOutlet UITextField *WeightTxt;
@property (weak, nonatomic) IBOutlet UITextField *DescrTxt;
@property (weak, nonatomic) IBOutlet UITextField *PartNo1Txt;
@property (weak, nonatomic) IBOutlet UITextField *PartNo2Txt;
@property (weak, nonatomic) IBOutlet UIButton *AddToolBtn;

@end
