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
#import "tHybridUniversalEventAgentModule.h"


@implementation UIViewController (tHybridWeex)

- (void)renderWeex{
    [self renderWeexWithOptions:self.options];
}

- (void)renderWeexWithOptions:(NSObject *)options{
    [self.weexInstance destroyInstance];
    self.weexInstance = [[WXSDKInstance alloc] init];
    self.weexInstance.viewController = self;
    if (self.contentView) {
        CGRect frame = self.contentView.frame;
        frame.origin = CGPointZero;
        self.weexInstance.frame = frame;
    } else {
        self.weexInstance.frame = self.view.frame;
    }

    self.renderOption = thybridRenderOptionOnRendering;
    __weak typeof(self) weakSelf = self;
    self.weexInstance.onCreate = ^(UIView *view) {
        weakSelf.renderOption |= thybridRenderOptionOnCreate;

        //进行安全校验，避免出现运行时Crash现象
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf onCreate:view];

    };
    self.weexInstance.onFailed = ^(NSError *error) {
        //process failure
        weakSelf.renderOption |= thybridRenderOptionOnFail;
        [weakSelf onFailed:error];
    };

    self.weexInstance.renderFinish = ^ (UIView *view) {
        //process renderFinish
        weakSelf.renderOption |= thybridRenderOptionOnFinish;
        [weakSelf renderFinish:view];
    };
    NSMutableDictionary *GlobalEvent = [NSMutableDictionary dictionary];
    [GlobalEvent setValue:tHybridUniversalEventAgentModule.GlobalEventRefreshInstance forKey:@"GlobalEventRefreshInstance"];

    [self.weexInstance renderWithURL:self.weexUrl options:@{@"GlobalEvent":GlobalEvent} data:nil];
    self.options = options;
}
- (void)refreshWeexInstance{
    [self.weexInstance fireGlobalEvent:tHybridUniversalEventAgentModule.GlobalEventRefreshInstance params:self.options];
}
- (void)renderFinish:(UIView *)view{
    if (self.options) {
        [self refreshWeexInstance];
    }
}

- (void)onFailed:(NSError *)error{

}

- (void)onCreate:(UIView *)view{
    if (!self.contentView) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
        CGRect frame = self.view.frame;
        frame.origin = CGPointZero;
        contentView.frame = frame;
        [self.view addSubview:contentView];
        self.contentView = contentView;
        [self.contentView addSubview:view];
    }
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
//@synthesize renderOption;
static void *renderOption = &renderOption;
- (thybridRenderOption)renderOption{
    NSNumber *obj = objc_getAssociatedObject(self, &renderOption);
    if (!obj.integerValue) {
        return thybridRenderOptionUnknown;
    }
    return (thybridRenderOption)[obj integerValue];
}
- (void)setRenderOption:(thybridRenderOption)Property{
    objc_setAssociatedObject(self, &renderOption, @(Property), OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)springWithURL:(NSString *)url option:(NSDictionary *)option{
    if (!url.length) {
        return ;
    }
    [self performBlock:^{
        UIViewController *VC = [[UIViewController alloc] init];
        VC.weexUrl = [NSURL weexUrlWithFilePath:url];
        if ([self isKindOfClass:UINavigationController.class]) {
            [(UINavigationController *)self pushViewController:VC animated:YES];
        } else {
            [self.navigationController pushViewController:VC animated:YES];
        }
        [VC renderWeexWithOptions:option];
    }];
}
- (void)performBlock:(void(^)(void))blocks{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        blocks();
    }];
}
@end
