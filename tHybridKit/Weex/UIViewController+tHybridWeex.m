//
//  UIViewController+Weex.m
//  Weex
//
//  Created by Dao on 2018/1/18.
//  Copyright © 2018年 Taocaimall. All rights reserved.
//

#import "UIViewController+tHybridWeex.h"

#import "NSURL+tHybrid.h"


@implementation UIViewController (tHybridWeex)

//@dynamic weexInstance;
//@dynamic weexView;
//@dynamic weexUrl;
//@dynamic options;
//@dynamic renderFailed;

- (void)renderWeex{
    [self renderWeexWithOptions:nil];
}

- (void)renderWeexWithOptions:(NSDictionary *)options{

    __weak typeof(self) weakSelf = self;
    self.weexInstance.onCreate = ^(UIView *view) {
        weakSelf.renderFailed = NO;
        //进行安全校验，避免出现运行时Crash现象
        [weakSelf onCreate:view];

    };
    self.weexInstance.onFailed = ^(NSError *error) {
        //process failure
        weakSelf.renderFailed = YES;
        [weakSelf onFailed:error];
    };

    self.weexInstance.renderFinish = ^ (UIView *view) {
        //process renderFinish
        [weakSelf renderFinish:view];
    };
    [self.weexInstance renderWithURL:self.weexUrl options:options data:nil];
}

- (void)renderFinish:(UIView *)view{

}

- (void)onFailed:(NSError *)error{

}

- (void)onCreate:(UIView *)view{
 
}

- (void)rightBarButtonItem{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_basket"] style:(UIBarButtonItemStylePlain) target:self action:@selector(springToBasket)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)springToBasket{

}


@end
