//
//  ToolTypeCell.m
//  Tools
//
//  Created by Mazin Biviji on 12/5/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "ToolTypeCell.h"

@implementation ToolTypeCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)ToolTypeValueChanged:(id)sender {
    
    switch (self.ToolTypeSegControl.selectedSegmentIndex) {
        case 0:
            self.UpdatedValue = @"Stamping die";
            break;
        case 1:
            self.UpdatedValue = @"Injection mold";
            break;
        case 2:
            self.UpdatedValue = @"Check fixture";
            break;
        case 3:
            self.UpdatedValue = @"Gauge";
            break;
        default:
            self.UpdatedValue = @"Other";
            break;
    }
    
    [self postNotifcationPartNoLookUpComplete];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)postNotifcationPartNoLookUpComplete{
    
    //updateArray format:(NSString)isUpdated (NSString)ParseClass (NSString)PraseKey (NSString)UpdatedValue
    NSString* isUpdated = @"NotUpdated";
    if (![self.UpdatedValue isEqualToString:self.initialValue]) {
        isUpdated = @"Updated";
    }
    
    NSMutableDictionary *updateDict = [NSMutableDictionary dictionaryWithObjects:@[isUpdated,@"Tools",[NSNumber numberWithInt:self.parseKeyIndex],self.UpdatedValue] forKeys:@[@"isUpdated",@"ParseClass",@"ParseKey",@"UpdatedValue"]];
    
    NSDictionary *UserInfo = [NSDictionary dictionaryWithObjectsAndKeys:updateDict,@"updateArray", nil];
    
    NSString *notificationName = @"PartNoLookUpComplete";
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:self
                                                      userInfo:UserInfo];
    
}

@end
