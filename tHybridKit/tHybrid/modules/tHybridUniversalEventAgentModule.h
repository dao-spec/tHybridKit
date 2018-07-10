//
//  tHybridUniversalEventAgentModule.h
//  tHybridKit
//
//  Created by Dao on 2018/3/14.
//

#import <Foundation/Foundation.h>

#import "WXModuleProtocol.h"
#import "tHybridWebProtocol.h"
#import "NSObject+EventMap.h"


@interface tHybridUniversalEventAgentModule : NSObject<WXModuleProtocol, tHybridWebModuleProtocol>

@property (class, nonatomic, copy, readonly) NSString *GlobalEventRefreshInstance;

@end
