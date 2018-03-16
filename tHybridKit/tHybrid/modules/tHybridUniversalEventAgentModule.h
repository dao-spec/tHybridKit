//
//  tHybridUniversalEventAgentModule.h
//  tHybridKit
//
//  Created by Dao on 2018/3/14.
//

#import <Foundation/Foundation.h>

#import <WXModuleProtocol.h>
#import "tHybridWebProtocol.h"

typedef JSValue* tHybridModuleCallback;

#define THYBRID_MODULE_API(module)  module##Protocol

@protocol THYBRID_MODULE_API(tHybridUniversalEventAgentModule)<tHybridWebModuleProtocol, JSExport>

/**
 *  同步请求
 *
 *  @param eventName 事件名称
 *  @param eventType 事件类型
 *  @param eventData 数据参数
 *  @return 返回值/NULL
 */
- (id)syncEvent:(NSString *)eventName :(NSString *)eventType :(id)eventData;


/**
 *  异步请求
 *
 *  @param eventName 事件名称
 *  @param eventType 事件类型
 *  @param eventData 数据参数
 *  @param callback 回调Block【H5为回调的方法名称,Weex为WXModuleCallback类型的Block】
 */
- (void)asynEvent:(NSString *)eventName :(NSString *)eventType :(id)eventData :(tHybridModuleCallback/*WXModuleCallback*/)callback;

@end

@interface tHybridUniversalEventAgentModule : NSObject<WXModuleProtocol, tHybridWebModuleProtocol/*THYBRID_MODULE_API(tHybridUniversalEventAgentModule)*/>


@end
