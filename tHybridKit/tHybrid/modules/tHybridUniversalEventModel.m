//
//  tHybridUniversalEventModel.m
//  tHybridKit
//
//  Created by Dao on 2018/3/7.
//

#import "tHybridUniversalEventModel.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface tHybridUniversalEventModel()

@property (nonatomic, strong) JSValue *jsValue;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventType;
@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, copy) WXModuleCallback callbackBlock;
@end

@implementation tHybridUniversalEventModel

//+ (instancetype)eventWithName:(NSString *)eventName eventType:(NSString *)eventType data:(NSDictionary *)data{
//    return [[tHybridUniversalEventModel alloc] initWithName:eventName eventType:eventType data:data callback:nil];
//}
+ (instancetype)eventWithName:(NSString *)eventName eventType:(NSString *)eventType data:(NSDictionary *)data callback:(id)callback{
    return [[tHybridUniversalEventModel alloc] initWithName:eventName eventType:eventType data:data callback:callback];
}

- (instancetype)initWithName:(NSString *)eventName eventType:(NSString *)eventType data:(NSDictionary *)data callback:(id)callback{
    if (self = [super init]) {
        self.eventName = eventName;
        self.eventType = eventType;
        self.data = [data copy];

        if (callback) {
            if ([callback isKindOfClass:JSValue.class]) {
                __block tHybridUniversalEventModel *blockSelf = self;
                WXModuleCallback cbBlock = ^(id result){
                    [blockSelf.jsValue callWithArguments:@[result]];
                };
                self.callbackBlock = cbBlock;
            } else {
                self.callbackBlock = callback;
            }
        }

    }

    return self;

}

- (NSString *)description{
    return [NSString stringWithFormat:@"<eventName = %@; eventType = %@; data = %@; callback = %@>", self.eventName, self.eventType, self.data, self.callbackBlock];
}


@end

