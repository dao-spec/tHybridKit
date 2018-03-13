//
//  tHybridEvent.m
//  tHybridKit
//
//  Created by Dao on 2018/3/7.
//

#import "tHybridEvent.h"

@implementation tHybridEvent

+ (instancetype)eventWithName:(NSString *)eventName eventType:(NSString *)eventType data:(NSDictionary *)data{
    tHybridEvent *event = [[tHybridEvent alloc] init];

    event.eventName = eventName;
    event.eventType = eventType;
    event.data = [data copy];

    return event;
}

@end

