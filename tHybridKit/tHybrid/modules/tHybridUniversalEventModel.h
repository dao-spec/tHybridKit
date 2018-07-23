//
//  tHybridUniversalEventModel.h
//  tHybridKit
//
//  Created by Dao on 2018/3/7.
//

#import <Foundation/Foundation.h>

#import "WXModuleProtocol.h"

typedef NS_ENUM(NSUInteger, tHybridUniversalEventErrorCode) {
    /** 请求正常 */
    tHybridUniversalEventErrorCodeSuccess = 0,
    /** 未知错误 */
    tHybridUniversalEventErrorCodeUnknown = 1000,
    /** 请求错误：请求的操作无法识别 */
    tHybridUniversalEventErrorCodeRequestError = 1001,
    /** 数据异常：请求的数据 */
    tHybridUniversalEventErrorCodeDataAnomaly = 1002,

};

FOUNDATION_EXTERN NSString *const tHybridUniversalEventAgentModuleName;
/**
 *  tHybrid事件对象模型
 */
@interface tHybridUniversalEventModel : NSObject

@property (nonatomic, copy, readonly) NSString *eventName;
@property (nonatomic, copy, readonly) NSString *eventType;
@property (nonatomic, copy, readonly) NSDictionary *data;

@property (nonatomic, copy, readonly) WXModuleCallback callbackBlock;

/** Android不支持直接返回 */
//+ (instancetype)eventWithName:(NSString *)eventName eventType:(NSString *)eventType data:(NSDictionary *)data;
+ (instancetype)eventWithName:(NSString *)eventName eventType:(NSString *)eventType data:(NSDictionary *)data callback:(id)callback;

@end


