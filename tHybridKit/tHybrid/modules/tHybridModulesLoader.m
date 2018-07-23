//
//  tHybridModulesLoader.m
//  tHybridKit
//
//  Created by Dao on 2018/3/14.
//

#import "tHybridModulesLoader.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>

#import "tHybridUniversalEventAgentModule.h"




NSString *const tHybridUniversalEventAgentModuleName = @"EventAgent";

NSMutableDictionary *tHybridModelMap = nil;

@implementation tHybridModulesLoader

+ (void)loadModels:(void(^)(Class modelClass, NSString *modelName))registerBlock{
    tHybridModelMap = [NSMutableDictionary dictionary];
    /**
     *  加载默认事件module
     */
    registerBlock(tHybridUniversalEventAgentModule.class, tHybridUniversalEventAgentModuleName);
    [tHybridModelMap setValue:tHybridUniversalEventAgentModule.class forKey:tHybridUniversalEventAgentModuleName];


    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"weexConfiguration" ofType:@"plist"];
    if (!filePath) {
        return;
    }
#ifdef DEBUG
    else {
        NSLog(@"---------------------------------\ntHybrid 开始Module注册\n\n");
    }
#endif
    NSDictionary *weexConfiguration = [NSDictionary dictionaryWithContentsOfFile:filePath];

    for (NSString *key in weexConfiguration.allKeys) {
        Class class = NSClassFromString([weexConfiguration valueForKey:key]);
        if (class) {
            registerBlock(class, key);
            NSLog(@"Module %@ 注册成功", key);
            [tHybridModelMap setValue:class forKey:key];
        }
#ifdef DEBUG
        else {
            NSLog(@"Module %@ 注册失败", key);
        }
#endif
    }

    NSLog(@"\n\n\ntHybrid 完成Module注册\n---------------------------------");
}

+ (Class)classWithModuleName:(NSString *)moduleName{
    Class class = tHybridModelMap[moduleName];
    return class;
}

@end

@implementation tHybridModulesLoaderHelper
@synthesize webInstance;

THYBRID_EXPORT_METHOD_SYNC(@selector(requireModule:))
- (void)requireModule:(NSString *)module{
    if ([self.webInstance.modules valueForKey:module]) {
        return;
    }
    Class moduleClass = [tHybridModulesLoader classWithModuleName:module];
    
    NSObject<tHybridWebModuleProtocol,JSExport> *moduleInstance = [[moduleClass alloc] init];
    moduleInstance.webInstance = self.webInstance;
    
    self.webInstance.jsContext[module] = [moduleInstance webModuleFuctionMap];
    [self.webInstance.modules setValue:moduleInstance forKey:module];
}


@end
