//
//  UIViewController+Weex.h
//  Weex
//
//  Created by Dao on 2018/1/18.
//  Copyright © 2018年 Taocaimall. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "tHybridSpringReceiveProtocol.h"
#import "tHybridWeexProtocol.h"
#import "NSObject+tHybridURL.h"




@interface UIViewController (tHybridWeex) <tHybridWeexProtocol, tHybridSpringReceiveProtocol>

/**
 * 渲染Weex
 */
- (void)renderWeex;


/**
 * 渲染Weex并携带参数
 *
 * @param options 渲染所需参数
 */
- (void)renderWeexWithOptions:(NSDictionary *)options;

- (void)rightBarButtonItem;

@end
