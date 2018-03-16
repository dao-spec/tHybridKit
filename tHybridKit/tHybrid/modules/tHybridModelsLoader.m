//
//  tHybridModelsLoader.m
//  tHybridKit
//
//  Created by Dao on 2018/3/14.
//

#import "tHybridModelsLoader.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>

#import "tHybridUniversalEventAgentModule.h"


NSString *const tHybridUniversalEventAgentModuleName = @"EventAgent";

NSMutableDictionary *tHybridModelMap = nil;

@implementation tHybridModelsLoader

+ (void)loadModels:(void(^)(Class modelClass, NSString *modelName))registerBlock{
    tHybridModelMap = [NSMutableDictionary dictionary];
    /**
     *  加载默认事件module
     */
    registerBlock(tHybridUniversalEventAgentModule.class, tHybridUniversalEventAgentModuleName);
    [self loadConfiguration:tHybridUniversalEventAgentModule.class];
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
            [self loadConfiguration:class];
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

/*
 *
 */
+ (void)loadConfiguration:(Class)theClass{
    return;
    uint outCount;
    Method *methodList = class_copyMethodList(object_getClass(theClass), &outCount);

    for (uint index=0; index < outCount; index++) {
        Method method = methodList[index];

        NSLog(@"%@", NSStringFromSelector(method_getName(method)));

        NSString *methodName = NSStringFromSelector(method_getName(method));
        if (![methodName hasPrefix:@"thybrid_export_method_sync"]) {
            continue;
        }

        SEL selector = method_getName(method);

        NSString *IMP_name = [theClass performSelector:selector withObject:nil];



    }


    return;

}

+ (Class)classWithModuleName:(NSString *)moduleName{
    Class class = tHybridModelMap[moduleName];
    return class;
}

@end
