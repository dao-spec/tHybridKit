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
#import "UIView+GDViewFromXIB.h"



@interface UIViewController (tHybridWeex) <tHybridWeexProtocol, tHybridSpringReceiveProtocol>

@property(nonatomic, assign) BOOL navigationStatus;
@property(nonatomic, assign) BOOL navigationAnimate;

/**
 * 渲染Weex
 */
- (void)renderWeex;
- (void)renderWeexWithURL:(NSURL *)url;

/**
 * 渲染Weex并携带参数
 *
 * @param options 渲染所需参数
 */
- (void)renderWeexWithOptions:(NSObject *)options;
- (void)refreshWeexInstance;

- (void)rightBarButtonItem;


- (void)springWithURL:(NSString *)url option:(NSDictionary *)option;
@end
