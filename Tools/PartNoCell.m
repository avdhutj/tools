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


- (IBAction)PartNoTextEditingDidBegin:(id)sender {
    
    if ([self.TextField.text isEqualToString:@"New part number"]) {
        self.TextField.text = @"";
    }
}


- (IBAction)PartTextCell:(id)sender {
    
    if ([self.TextField.text isEqualToString:@""] && [self.initialValue isEqualToString:@"New part number"]) {
        self.TextField.text = @"New part number";
    }
    
    PFQuery *partNumbers = [PFQuery queryWithClassName:@"PartNumbers"];
    [partNumbers whereKey:@"name" equalTo:self.TextField.text];
    [partNumbers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error) {
            if ([objects count] > 1) {
                //Need to update this so it is flagged for review
                self.PartStatusLbl.text = @"Multiple";
                self.updatedObjectId = @"toReview";
            }
            else {
                if ([objects count] == 0) {
                    self.PartStatusLbl.text = @"Add Part No";
                    self.updatedObjectId = @"new";
                } else {
                    self.PartStatusLbl.text = [objects[0] objectForKey:@"status"];
                    PFObject* partNo = objects[0];
                    self.updatedObjectId = partNo.objectId;
                }
            }
            
        } else {
            
            NSLog(@"%@",[error userInfo]);
            
        }
        //Post notifcation once the block operation is complete
        [self postNotifcationPartNoLookUpComplete];
    }];
}

-(void)postNotifcationPartNoLookUpComplete{
    //updateArray format:(NSString)isUpdated (NSString)ParseClass (NSString)PraseKey (NSString)UpdatedValue (NSString)UpdateObjectId (int)UpdateIndexNo (NSString)UpdatedStatus
    NSString* isUpdated = @"NotUpdated";
    if (![self.TextField.text isEqualToString:self.initialValue]) {
        isUpdated = @"Updated";
        if([self.initialValue isEqualToString:@"New part number"]){
            isUpdated = @"UpdatedAdd";
        }
    }
    
    NSMutableDictionary *updateDict = [NSMutableDictionary dictionaryWithObjects:@[isUpdated,@"PartNumbers",@"name",self.TextField.text,self.updatedObjectId,[NSNumber numberWithInt:self.ArrayIndex],self.PartStatusLbl.text] forKeys:@[@"isUpdated",@"ParseClass",@"PartKey",@"UpdatedValue",@"UpdateObjectId",@"UpdateIndexNo",@"UpdatedStatus"]];
    
    //NSArray *updateArray = @[isUpdated,@"name",self.TextField.text];
    NSDictionary *UserInfo = [NSDictionary dictionaryWithObjectsAndKeys:updateDict,@"updateArray", nil];
    
    NSString *notificationName = @"PartNoLookUpComplete";
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:self
                                                      userInfo:UserInfo];
    
}
     

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
