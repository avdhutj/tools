//
//  ToolTypeCell.h
//  Tools
//
//  Created by Mazin Biviji on 12/5/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolTypeCell : UITableViewCell

@property (nonatomic) int parseKeyIndex; //1 - 5 for values on tools detailes table
@property (nonatomic) NSString*initialValue;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ToolTypeSegControl;
@property (nonatomic) NSString* UpdatedValue;

@end
