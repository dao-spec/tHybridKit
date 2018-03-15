//
//  tHybridUniversalEventModel.h
//  tHybridKit
//
//  Created by Dao on 2018/3/7.
//

#import <Foundation/Foundation.h>

#import "WXModuleProtocol.h"

FOUNDATION_EXTERN NSString *const tHybridUniversalEventAgentModuleName;
/**
 *  tHybrid事件对象模型
 */
@interface tHybridUniversalEventModel : NSObject

@property (nonatomic, copy, readonly) NSString *eventName;
@property (nonatomic, copy, readonly) NSString *eventType;
@property (nonatomic, copy, readonly) NSDictionary *data;

@property (nonatomic, copy, readonly) WXModuleCallback callbackBlock;

+ (instancetype)eventWithName:(NSString *)eventName eventType:(NSString *)eventType data:(NSDictionary *)data;
+ (instancetype)eventWithName:(NSString *)eventName eventType:(NSString *)eventType data:(NSDictionary *)data callback:(id)callback;

@end


