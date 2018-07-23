//
//  tHybridUniversalEventAgentModule.m
//  tHybridKit
//
//  Created by Dao on 2018/3/14.
//

#import "tHybridUniversalEventAgentModule.h"

#import "tHybridSpringReceiveProtocol.h"
#import "UIViewController+tHybridWeex.h"
#import <objc/runtime.h>

typedef UIViewController<tHybridSpringReceiveProtocol> tHybridReceiveHandler;



@implementation tHybridUniversalEventAgentModule
@synthesize webInstance;
@synthesize weexInstance;


/**
 *  Weex + H5
 */
WX_EXPORT_METHOD(@selector(asynEvent:eventType:eventData:callback:));
THYBRID_EXPORT_METHOD(@selector(asynEvent:eventType:eventData:callback:));
- (void)asynEvent:(NSString *)eventName eventType:(NSString *)eventType eventData:(NSDictionary *)eventData callback:(WXModuleCallback)callback{
    tHybridReceiveHandler *handler = nil;

    if (self.webInstance) {
        handler = (tHybridReceiveHandler *)self.webInstance.viewController;
    } else if (self.weexInstance) {
        handler = (tHybridReceiveHandler *)self.weexInstance.viewController;
    }
    id value = nil;
    if ([callback isKindOfClass:JSValue.class]) {
        value = [JSValue valueWithObject:callback inContext:self.webInstance.jsContext];
    } else {
        value = callback;
    }

    //
    tHybridUniversalEventModel *event = [tHybridUniversalEventModel eventWithName:eventName eventType:eventType data:eventData callback:value];

    if ([handler respondsToSelector:@selector(responsetHybridUniversalEventModel:)]) {
        [handler responsetHybridUniversalEventModel:event];
    } else {
        NSLog(@"%@ cann't responds the event:%@", NSStringFromClass(handler.class), event);
    }
}



WX_EXPORT_METHOD_SYNC(@selector(springWithWeexUrl:option:));
- (void)springWithWeexUrl:(NSString *)weexUrl option:(NSDictionary *)option{
    if (!weexUrl) {
        return ;
    }

    tHybridReceiveHandler *handler = nil;
    if (self.webInstance) {
        handler = (tHybridReceiveHandler *)self.webInstance.viewController;
    } else if (self.weexInstance) {
        handler = (tHybridReceiveHandler *)self.weexInstance.viewController;
    }

    [handler springWithURL:weexUrl option:option];
}

WX_EXPORT_METHOD_SYNC(@selector(setPageTitle:));
- (void)setPageTitle:(NSString *)pageTitle{
    tHybridReceiveHandler *handler = nil;
    if (self.webInstance) {
        handler = (tHybridReceiveHandler *)self.webInstance.viewController;
    } else if (self.weexInstance) {
        handler = (tHybridReceiveHandler *)self.weexInstance.viewController;
    }
    handler.title = pageTitle;
}

WX_EXPORT_METHOD(@selector(leftBarButtonAction));
- (void)leftBarButtonAction{
    tHybridReceiveHandler *handler = nil;
    if (self.webInstance) {
        handler = (tHybridReceiveHandler *)self.webInstance.viewController;
    } else if (self.weexInstance) {
        handler = (tHybridReceiveHandler *)self.weexInstance.viewController;
    }
    SEL selector = NSSelectorFromString(@"leftBarButtonAction");
    Method method = class_getInstanceMethod(handler.class, selector);
    IMP imp = method_getImplementation(method);
    void (*func)(id, SEL) = (void *)imp;

    func(handler, selector);
}


+ (NSString *)GlobalEventRefreshInstance{
    return @"tHybridUniversalEventAgentModule_GlobalEventRefreshInstance";
}

+ (NSString *)EventNamePage{
    NSString *className = NSStringFromClass(self);
    NSString *methodName = NSStringFromSelector(@selector(EventNamePage));
    return [NSString stringWithFormat:@"%@_%@", className, methodName];
}



WX_EXPORT_METHOD(@selector(EventMap:));
- (void)EventMap:(WXModuleCallback)callback{
    callback([self.class EventMap]);
}

+ (NSMutableDictionary *)EventMap{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[self GlobalEventRefreshInstance] forKey:@"GlobalEventRefreshInstance"];
    [dic setValue:[self EventNamePage] forKey:@"EventNamePage"];

    uint outCount;
    Method *claMethodList = class_copyMethodList(object_getClass(self.class), &outCount);

    for (int index=0; index < outCount; index++) {
        Method claMethod = claMethodList[index];

        NSString *claMethodName = NSStringFromSelector(method_getName(claMethod));
        if ([claMethodName hasPrefix:@"THYBRID_EVENT_BINDING_TOKEN"]) {
            SEL claSelector = method_getName(claMethod);
            NSString* (*func)(id, SEL) = (NSString* (*)(id, SEL))method_getImplementation(claMethod);
            NSString *eventValue = func(self, claSelector);
            NSString *eventKey = [claMethodName stringByReplacingOccurrencesOfString:@"THYBRID_EVENT_BINDING_TOKEN" withString:@""];
            if (eventKey && eventValue) {
                [dic setValue:eventValue forKey:eventKey];
            }
        }
    }

    free(claMethodList);


    return dic;
}

+ (BOOL)checkEventName:(NSString *)eventName{
    if ([self.EventNamePage isEqualToString:eventName]) {
        return YES;
    }

    return NO;
}
/**
 *  H5+Weex
 */
/*
WX_EXPORT_METHOD_SYNC(@selector(syncEvent:::));
- (void)syncEvent:(NSString *)eventName :(NSString *)eventType :(NSDictionary *)eventData{

    tHybridReceiveHandler *handler = nil;

    if (self.webInstance) {
        handler = (tHybridReceiveHandler *)self.webInstance.viewController;
    } else if (self.weexInstance) {
        handler = (tHybridReceiveHandler *)self.weexInstance.viewController;
    }

    //
    tHybridUniversalEventModel *event = [tHybridUniversalEventModel eventWithName:eventName eventType:eventType data:eventData];

    if ([handler respondsToSelector:@selector(responsetHybridUniversalEventModel:)]) {
        [handler responsetHybridUniversalEventModel:event];
    } else {
        NSLog(@"%@ cann't responds the event:%@", NSStringFromClass(handler.class), event);
    }
}
*/
@end
