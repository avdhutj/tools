//
//  PartNoCell.h
//  Tools
//
//  Created by Mazin Biviji on 11/29/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PartNoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *TextField;
@property (weak, nonatomic) IBOutlet UILabel *PartStatusLbl;
@property int ArrayIndex;
@property (nonatomic) NSString*updatedObjectId;
@property (nonatomic) NSString*initialValue;

@end
