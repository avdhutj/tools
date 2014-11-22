//
//  ToolDetailViewController.m
//  Tools
//
//  Created by Mazin Biviji on 11/21/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "ToolDetailViewController.h"

@interface ToolDetailViewController ()

@end

@implementation ToolDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Here");
    // Do any additional setup after loading the view.
    self.examTitle.text = [self.exam objectForKey:@"toolID"];
    NSLog(@"%@", [self.exam objectForKey:@"toolID"]);
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
