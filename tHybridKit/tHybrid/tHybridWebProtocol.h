//
//  tHybridWebProtocol.h
//  tHybridKit
//
//  Created by Dao on 2018/3/12.
//

#import <Foundation/Foundation.h>
#import <tHybridWebInstance.h>
#import "NSObject+ModuleMap.h"


#define THYBRID_EXPORT_METHOD(method)  \
+ (NSString *)WX_CONCAT_WRAPPER(thybrid_export_method_, __LINE__) { \
return NSStringFromSelector(method); \
}
#define THYBRID_EXPORT_METHOD_SYNC(method) \
+ (NSString *)WX_CONCAT_WRAPPER(thybrid_export_method_sync_, __LINE__) { \
return NSStringFromSelector(method); \
}

@protocol tHybridWebProtocol <NSObject>

@required
@property (nonatomic, strong) tHybridWebInstance *webInstance;

@optional
- (NSArray *)arrayForRequiredModels;


@end



@protocol tHybridWebModuleProtocol <NSObject>

@property (nonatomic, weak) tHybridWebInstance *webInstance;

@optional
+ (NSMutableDictionary *)webModuleFuctionMap;

@end
