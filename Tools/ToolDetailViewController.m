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
    
    /*[self.exam setObject:[NSArray arrayWithObjects:@"MDX3Hui5jt", nil] forKey:@"part"];
    [self.exam saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Saved.");
        } else {
            NSLog(@"Not Saved");
        }
    }];*/
    
    NSString* toolStatus = [NSString stringWithFormat:@"TBD"];
    NSArray *partIDs = [self.exam objectForKey:@"part"];
    
    for (NSString* part in partIDs){
        [self.partNumbers addObject:[PFObject objectWithClassName:part]];
    };
    
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
