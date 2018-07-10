//
//  NSObject+EventMap.h
//  DTCoreText
//
//  Created by Dao on 2018/7/5.
//

#import <Foundation/Foundation.h>
#import "WXModuleProtocol.h"

@interface NSObject (EventMap)<WXModuleProtocol>

- (NSDictionary *)eventMap;
- (void)EventMap:(WXModuleCallback)callback;

@end
