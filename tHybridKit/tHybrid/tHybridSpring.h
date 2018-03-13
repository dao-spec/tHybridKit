//
//  tHybridSpring.h
//  Weex
//
//  Created by Dao on 2018/1/17.
//  Copyright © 2018年 淘菜猫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WXModuleProtocol.h"
#import "tHybridEvent.h"
#import "tHybridWebProtocol.h"

@protocol tHybridSpringMoudleProtocol <tHybridMoudleProtocol, JSExport>

- (id)sendEvent:(NSString *)eventName :(NSString *)eventType :(NSDictionary *)data;

@end



/**
 *  Weex事件传递Adapter
 */
@interface tHybridSpring : NSObject <WXModuleProtocol,tHybridSpringMoudleProtocol>

- (id)sendEvent:(NSString *)eventName eventType:(NSString *)eventType eventData:(NSDictionary *)data;

@end
