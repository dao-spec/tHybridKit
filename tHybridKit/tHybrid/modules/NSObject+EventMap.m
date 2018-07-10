//
//  NSObject+EventMap.m
//  DTCoreText
//
//  Created by Dao on 2018/7/5.
//

#import "NSObject+EventMap.h"

@implementation NSObject (EventMap)

WX_EXPORT_METHOD(@selector(EventMap:));
- (void)EventMap:(WXModuleCallback)callback{
    NSDictionary *option = @{@"event":[self eventMap]?:@{}};
    callback(option);
}
- (NSDictionary *)eventMap{
    return @{};
}

@end
