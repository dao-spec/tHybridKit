//
//  UIViewController+Weex.m
//  Weex
//
//  Created by Dao on 2018/1/18.
//  Copyright © 2018年 Taocaimall. All rights reserved.
//

#import "UIViewController+tHybridWeex.h"

#import "NSURL+tHybrid.h"
#import <objc/runtime.h>


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
#define THYBRID_ADD_PROPERTY(Property,property,TYPE,ASSOCIATION_RETAIN)    \
static void *k##property = &k##property;    \
- (TYPE *)property{ \
TYPE *obj = objc_getAssociatedObject(self, &k##property);   \
return obj; \
} \
- (void)set##Property:(TYPE *)Property{ \
objc_setAssociatedObject(self, &k##property, Property, ASSOCIATION_RETAIN);    \
}

//@synthesize weexInstance;
THYBRID_ADD_PROPERTY(WeexInstance, weexInstance, WXSDKInstance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//@synthesize weexView;
THYBRID_ADD_PROPERTY(WeexView, weexView, UIView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//@synthesize weexUrl;
THYBRID_ADD_PROPERTY(WeexUrl, weexUrl, NSURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//@synthesize options;
THYBRID_ADD_PROPERTY(Options, options, NSObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//@synthesize contentView;
THYBRID_ADD_PROPERTY(ContentView, contentView, UIView, OBJC_ASSOCIATION_ASSIGN);
//@synthesize renderFailed;
static void *krenderFailed = &krenderFailed;
- (BOOL)renderFailed{
    NSNumber *obj = objc_getAssociatedObject(self, &krenderFailed);
    return [obj boolValue];
}
- (void)setRenderFailed:(BOOL)Property{
    objc_setAssociatedObject(self, &krenderFailed, @(Property), OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
