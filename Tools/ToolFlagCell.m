//
//  ToolFlagCell.m
//  Tools
//
//  Created by Mazin Biviji on 12/5/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "ToolFlagCell.h"

@implementation ToolFlagCell

- (void)awakeFromNib {
    // Initialization code
    self.flagSegControl.selectedSegmentIndex = [self.initialValue integerValue];
    NSLog(@"flag intialization: %i",[self.initialValue integerValue]);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (IBAction)flagChanged:(id)sender {
    self.UpdatedValue = [NSNumber numberWithInt:self.flagSegControl.selectedSegmentIndex];
    
    [self postNotifcationPartNoLookUpComplete];
}

-(void)postNotifcationPartNoLookUpComplete{
    
    //updateArray format:(NSString)isUpdated (NSString)ParseClass (NSString)PraseKey (NSString)UpdatedValue
    NSString* isUpdated = @"NotUpdated";
    if ([self.UpdatedValue integerValue] != [self.initialValue integerValue]) {
        isUpdated = @"Updated";
    }
    
    NSLog(@"In Post notification: %i",[self.UpdatedValue integerValue]);
    
    NSMutableDictionary *updateDict = [NSMutableDictionary dictionaryWithObjects:@[isUpdated,@"toolFlag",[NSNumber numberWithInt:self.parseKeyIndex],self.UpdatedValue] forKeys:@[@"isUpdated",@"ParseClass",@"ParseKey",@"UpdatedValue"]];
    
    NSDictionary *UserInfo = [NSDictionary dictionaryWithObjectsAndKeys:updateDict,@"updateArray", nil];
    
    NSString *notificationName = @"PartNoLookUpComplete";
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:self
                                                      userInfo:UserInfo];
    
}

@end
