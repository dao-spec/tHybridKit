//
//  UIView+GDViewFromXIB.h
//  Merchants
//
//  Created by Dao on 3/9/16.
//  Copyright © 2016 光典. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GDViewFromXIB)
+ (instancetype)viewFromXIB;
- (void)removeAllSubview;
@end
