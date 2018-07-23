//
//  tHybridKitModule.h
//  AFNetwork
//
//  Created by Dao on 2018/7/19.
//

#import <Foundation/Foundation.h>


#import "tHybridUniversalEventAgentModule.h"


#define THYBRID_BINDING_EVENT(event)   THYBRID_EVENT_BINDING(event)




@interface tHybridKitModule : tHybridUniversalEventAgentModule


/**
 *  全局通用监听事件：刷新实例对象【子类不需要实现】
 *
 *  @return 返回系统全局通用事件
 */
+ (NSString *)GlobalEventRefreshInstance NS_REQUIRES_SUPER;


/**
 *  获取当前模块对应的页面值
 *
 *  @return 该模块对应的页面值
 */
@property(class, nonatomic, copy, readonly) NSString *EventNamePage;



/************************************************************************/
/*                           以下方法不需要实现                            */
/*                                                                      */
/*                           以下方法不需要实现                            */
/*                                                                      */
/*                           以下方法不需要实现                            */
/************************************************************************/
- (void)leftBarButtonAction;
- (void)setPageTitle:(NSString *)pageTitle;
- (void)springWithWeexUrl:(NSString *)weexUrl option:(NSDictionary *)option;
- (void)asynEvent:(NSString *)eventName eventType:(NSString *)eventType eventData:(NSDictionary *)eventData callback:(WXModuleCallback)callback;
+ (BOOL)checkEventName:(NSString *)eventName;

@end
