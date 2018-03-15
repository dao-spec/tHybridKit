//
//  tHybridUniversalEventModel.m
//  tHybridKit
//
//  Created by Dao on 2018/3/7.
//

#import "tHybridUniversalEventModel.h"

@implementation tHybridUniversalEventModel

+ (instancetype)eventWithName:(NSString *)eventName eventType:(NSString *)eventType data:(NSDictionary *)data{
    tHybridUniversalEventModel *event = [[tHybridUniversalEventModel alloc] init];

    event.eventName = eventName;
    event.eventType = eventType;
    event.data = [data copy];

    return event;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<eventName = %@; eventType = %@; data= %@>", self.eventName, self.eventType, self.data];
}

@end

