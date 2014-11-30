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

}
- (IBAction)PartTextCell:(id)sender {
    NSLog(@"Part end editting: %@",self.TextField.text);
    [self.partNumbers whereKey:@"name" equalTo:self.TextField.text];
    [self.partNumbers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error) {
            if ([objects count] > 1) {self.PartStatusLbl.text = @"Multiple";}
            else {self.PartStatusLbl.text = [objects[0] objectForKey:@"status"];}
        } else {
            NSLog(@"%@",[error userInfo]);
            
        }
        
        [self.superview.superview reloadInputViews];
        
    }];
}
     

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
