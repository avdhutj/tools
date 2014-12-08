//
//  TextFieldCell.m
//  Tools
//
//  Created by Mazin Biviji on 11/30/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)TextCellDidEndEditing:(id)sender {
    
    [self postNotifcationPartNoLookUpComplete];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)postNotifcationPartNoLookUpComplete{

    //updateArray format:(NSString)isUpdated (NSString)ParseClass (NSString)PraseKey (NSString)UpdatedValue
    NSString* isUpdated = @"NotUpdated";
    if (![self.TextField.text isEqualToString:self.initialValue]) {
        isUpdated = @"Updated";
    }
    
    NSMutableDictionary *updateDict = [NSMutableDictionary dictionaryWithObjects:@[isUpdated,@"Tools",[NSNumber numberWithInt:self.parseKeyIndex],self.TextField.text] forKeys:@[@"isUpdated",@"ParseClass",@"ParseKey",@"UpdatedValue"]];
    
    NSDictionary *UserInfo = [NSDictionary dictionaryWithObjectsAndKeys:updateDict,@"updateArray", nil];
    
    NSString *notificationName = @"PartNoLookUpComplete";
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:self
                                                      userInfo:UserInfo];
    
}


@end
