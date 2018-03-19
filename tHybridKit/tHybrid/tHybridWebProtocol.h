//
//  tHybridWebProtocol.h
//  tHybridKit
//
//  Created by Dao on 2018/3/12.
//

#import <Foundation/Foundation.h>
#import "tHybridWebInstance.h"
#import "NSObject+ModuleMap.h"

#define THYBRID_EXPORT_METHOD_INTERNAL(method, token)    \
+ (NSString *)WX_CONCAT_WRAPPER(token, __LINE__) { \
return NSStringFromSelector(method); \
}


/**tHybrid Web异步方法*/
#define THYBRID_EXPORT_METHOD(method)  THYBRID_EXPORT_METHOD_INTERNAL(method, thybrid_export_method_)

/**tHybrid Web同步方法*/
#define THYBRID_EXPORT_METHOD_SYNC(method) THYBRID_EXPORT_METHOD_INTERNAL(method, thybrid_export_method_sync_)


@protocol tHybridWebProtocol <NSObject>

@required
@property (nonatomic, strong) tHybridWebInstance *webInstance;

@optional
- (NSArray *)arrayForRequiredModules;


@end



@protocol tHybridWebModuleProtocol <NSObject>

@property (nonatomic, weak) tHybridWebInstance *webInstance;

@end
