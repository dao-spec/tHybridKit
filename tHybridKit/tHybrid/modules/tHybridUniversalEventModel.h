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

@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventType;
@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, copy) WXModuleCallback callbackBlock;
@property (nonatomic, copy) NSString *callbackMethod;

+ (instancetype)eventWithName:(NSString *)eventName eventType:(NSString *)eventType data:(NSDictionary *)data;


@end


