//
//  tHybridUniversalEventAgentModule.m
//  tHybridKit
//
//  Created by Dao on 2018/3/14.
//

#import "tHybridUniversalEventAgentModule.h"

#import "tHybridUniversalEventModel.h"
#import "tHybridSpringReceiveProtocol.h"
#import "UIViewController+tHybridWeex.h"

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
        return;
    }

    NSLog(@"%@ cann't responds the event:%@", NSStringFromClass(handler.class), event);
}

/**
 *  H5+Weex
 */
WX_EXPORT_METHOD_SYNC(@selector(syncEvent:::));
- (NSDictionary *)syncEvent:(NSString *)eventName :(NSString *)eventType :(NSDictionary *)eventData{

    tHybridReceiveHandler *handler = nil;

    if (self.webInstance) {
        handler = (tHybridReceiveHandler *)self.webInstance.viewController;
    } else if (self.weexInstance) {
        handler = (tHybridReceiveHandler *)self.weexInstance.viewController;
    }

    //
    tHybridUniversalEventModel *event = [tHybridUniversalEventModel eventWithName:eventName eventType:eventType data:eventData];

    if ([handler respondsToSelector:@selector(responsetHybridUniversalEventModel:)]) {
        return [handler responsetHybridUniversalEventModel:event];
    }
    NSLog(@"%@ cann't responds the event:%@", NSStringFromClass(handler.class), event);

    return nil;
}

WX_EXPORT_METHOD_SYNC(@selector(springWithWeexUrl:option:));
- (NSString *)springWithWeexUrl:(NSString *)weexUrl option:(NSDictionary *)option{
    if (!weexUrl) {
        return @"weexUrl不能为空";
    }

    tHybridReceiveHandler *handler = nil;
    if (self.webInstance) {
        handler = (tHybridReceiveHandler *)self.webInstance.viewController;
    } else if (self.weexInstance) {
        handler = (tHybridReceiveHandler *)self.weexInstance.viewController;
    }

    [handler springWithURL:weexUrl option:option];
    return nil;
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

WX_EXPORT_METHOD(@selector(EventMap:));
- (void)EventMap:(WXModuleCallback)callback{
    [super EventMap:callback];
}
- (NSDictionary *)eventMap{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[super eventMap]?:@{}];
    [dic setValue:[tHybridUniversalEventAgentModule GlobalEventRefreshInstance] forKey:@"GlobalEventRefreshInstance"];

    return dic;
}

+ (NSString *)GlobalEventRefreshInstance{
    return @"SuperiorModuleGlobalEventRefreshInstance";
}
@end
