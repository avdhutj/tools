//
//  LoadView.m
//  Tools
//
//  Created by Avdhut Joshi on 11/22/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "LoadView.h"

@implementation LoadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self setCenter:CGPointMake(self.superview.center.x, self.superview.center.y)];
}

@end
