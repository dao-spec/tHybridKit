//
//  tHybridModelsLoader.h
//  tHybridKit
//
//  Created by Dao on 2018/3/14.
//

#import <Foundation/Foundation.h>

/*
 *  对外暴露的通用事件：EventAgent
 */
FOUNDATION_EXTERN NSString *const tHybridUniversalEventAgentModuleName;


@interface tHybridModelsLoader : NSObject

+ (void)loadModels:(void(^)(Class modelClass, NSString *modelName))registerBlock;

+ (Class)classWithModuleName:(NSString *)moduleName;

@end
