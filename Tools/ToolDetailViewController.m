//
//  ToolDetailViewController.m
//  Tools
//
//  Created by Mazin Biviji on 11/21/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "ToolDetailViewController.h"
#import <Parse/Parse.h>

@interface ToolDetailViewController ()

@end

@implementation ToolDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.examTitle.text = [self.exam objectForKey:@"toolID"];
    self.toolType.text = [self.exam objectForKey:@"toolType"];
    NSNumber *toolWeight = [self.exam objectForKey:@"weight"];
    self.toolWeight.text = [toolWeight stringValue];
    
    /*add part numbers
    [self.exam setObject:[NSArray arrayWithObjects:@"MDX3Hui5jt", nil] forKey:@"part"];
    [self.exam saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Saved.");
        } else {
            NSLog(@"Not Saved");
        }
    }];*/
    
    self.toolStatus = [NSString stringWithFormat:@"TBD"];
    //__block int obsCount = 0;
    int obsCount = 0;
    NSArray *partIDs = [self.exam objectForKey:@"part"];
    
    //Working w/o block operation
    PFQuery *query = [PFQuery queryWithClassName:@"PartNumbers"];
    for (NSString* part in partIDs){
        NSString *status = [[query getObjectWithId:part] objectForKey:@"status"];
        if([status isEqual:@"Active"]){
            self.toolStatus = status;
        } else if ([status isEqual:@"Obsolete"]){
            obsCount ++;
        }
    };
    
    //Add part numbers to array
    /*for (NSString* part in partIDs){
        PFQuery *query = [PFQuery queryWithClassName:@"PartNumbers"];
        NSLog(@"%@",part);
        [query getObjectInBackgroundWithId:part block:^(PFObject *object, NSError *error) {
            if (!error) {
                // The find succeeded.
                // Do something with the found object
                    [self.partNumbers addObject:object];
                    if ([[object objectForKey:@"status"] isEqualToString:@"Active"]) {
                        self.toolStatus = [NSString stringWithFormat:@"Active"];
                    } else if ([[object objectForKey:@"status"] isEqualToString:@"Obsolete"]) {
                        obsCount = obsCount +1;
                    }
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
        
        }];
    
    }*/
        
    if ([partIDs count]==obsCount) {
        self.toolStatus = @"Obsolete";
    }
    self.toolStatusLbl.text = self.toolStatus;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
