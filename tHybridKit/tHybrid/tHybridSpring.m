//
//  tHybridSpring.m
//  Weex
//
//  Created by Dao on 2018/1/17.
//  Copyright © 2018年 淘菜猫. All rights reserved.
//

#import "tHybridSpring.h"

#import "UIViewController+tHybridWeex.h"
#import <objc/runtime.h>



@implementation tHybridSpring

@synthesize weexInstance;
@synthesize webInstance;


WX_EXPORT_METHOD_SYNC(@selector(sendEvent:eventType:eventData:));
- (id)sendEvent:(NSString *)eventName eventType:(NSString *)eventType eventData:(NSDictionary *)data{

    UIViewController *handler = nil;
    if (self.webInstance) {
        handler = self.webInstance.viewController;
    } else if (self.weexInstance) {
        handler = self.weexInstance.viewController;
    }
    //
    tHybridEvent *event = [tHybridEvent eventWithName:eventName eventType:eventType data:data];

    if ([handler respondsToSelector:@selector(responseTHybridEvent:)]) {
        return [handler responseTHybridEvent:event];
    }
    return nil;
}



@end


