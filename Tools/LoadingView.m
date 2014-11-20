//
//  LoadingView.m
//  Tools
//
//  Created by Avdhut Joshi on 11/20/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [label setText:@"Loading"];
    
    [self addSubview:label];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
