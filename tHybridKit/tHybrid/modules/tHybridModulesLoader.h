//
//  tHybridModulesLoader.h
//  tHybridKit
//
//  Created by Dao on 2018/3/14.
//

#import <Foundation/Foundation.h>
#import "tHybridWebProtocol.h"

/*
 *  对外暴露的通用事件：EventAgent
 */
FOUNDATION_EXTERN NSString *const tHybridUniversalEventAgentModuleName;



/**
 * Modules加载器
 */
@interface tHybridModulesLoader : NSObject


/**
 * 加载Modules
 *
 * @param registerBlock 第三方加载Module的执行Block
 */
+ (void)loadModels:(void(^)(Class modelClass, NSString *modelName))registerBlock;


/**
 * 获取Modules对用的Class对象
 *
 * @param moduleName ModuleName
 * @return Class对象
 */
+ (Class)classWithModuleName:(NSString *)moduleName;

@end


@interface tHybridModulesLoaderHelper : NSObject<tHybridWebModuleProtocol>

@end
