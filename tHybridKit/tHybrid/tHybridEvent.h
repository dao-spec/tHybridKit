//
//  tHybridEvent.h
//  tHybridKit
//
//  Created by Dao on 2018/3/7.
//

#import <Foundation/Foundation.h>



/**
 *  tHybrid事件对象模型
 */
@interface tHybridEvent : NSObject

@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventType;
@property (nonatomic, strong) NSDictionary *data;

+ (instancetype)eventWithName:(NSString *)eventName eventType:(NSString *)eventType data:(NSDictionary *)data;


@end


