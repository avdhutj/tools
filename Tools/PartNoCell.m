//
//  PartNoCell.m
//  Tools
//
//  Created by Mazin Biviji on 11/29/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "PartNoCell.h"

@interface PartNoCell ()



@end

@implementation PartNoCell

- (void)awakeFromNib {
    // Initialization code
    //self.partNumbers
}
- (IBAction)PartTextCell:(id)sender {
    NSLog(@"Part end editting: %@",self.TextField.text);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
