//
//  UIView+GDViewFromXIB.m
//  Merchants
//
//  Created by Dao on 3/9/16.
//  Copyright © 2016 光典. All rights reserved.
//

#import "UIView+GDViewFromXIB.h"

@implementation UIView (GDViewFromXIB)

+ (instancetype)viewFromXIB
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return [nibContents lastObject];
}


- (void)removeAllSubview
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

@end
