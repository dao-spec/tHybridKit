//
//  tHybridUniversalEventAgentModule.h
//  tHybridKit
//
//  Created by Dao on 2018/3/14.
//

#import <Foundation/Foundation.h>

#import "WXModuleProtocol.h"
#import "tHybridWebProtocol.h"
#import "tHybridUniversalEventModel.h"


#define THYBRID_EXPORT_EVENT_INTERNAL(methodName, token)    \
+ (NSString *)WX_CONCAT_WRAPPER(token, methodName) { \
return [self methodName]; \
}


#define THYBRID_EVENT_BINDING(methodName) THYBRID_EXPORT_EVENT_INTERNAL(methodName,THYBRID_EVENT_BINDING_TOKEN)




@interface tHybridUniversalEventAgentModule : NSObject<WXModuleProtocol, tHybridWebModuleProtocol>

@end
