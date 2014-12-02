//
//  TextFieldCell.h
//  Tools
//
//  Created by Mazin Biviji on 11/30/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *TextField;
@property (nonatomic) int parseKeyIndex; //1 - 5 for values on tools detailes table
@property (nonatomic) NSString*initialValue;

@end
