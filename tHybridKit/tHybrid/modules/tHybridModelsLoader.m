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

+ (void)loadConfiguration:(Class)theClass{

    //theClass是否遵循JSExport协议
    if (!class_conformsToProtocol(theClass, @protocol(JSExport))) {
        return;
    }

    uint outCount;
    Method *methodList = class_copyMethodList(theClass, &outCount);
    NSMutableDictionary *methodMap = [NSMutableDictionary dictionary];
    for (uint index=0; index< outCount; index++) {

        Method method = methodList[index];
        struct objc_method_description *methodDes = method_getDescription(method);

        NSString *methodName = NSStringFromSelector(methodDes->name);

        [methodMap setValue:methodName forKey:[methodName componentsSeparatedByString:@":"].firstObject];

    }

    NSLog(@"methodMap:%@", methodMap);
    NSLog(@"--------------------------------");
    uint protoCount;
    Protocol * __unsafe_unretained _Nonnull *protoList = class_copyProtocolList(theClass, &protoCount);

    for (uint index=0; index < protoCount; index++) {
        Protocol *proto = protoList[index];

        if (!protocol_conformsToProtocol(proto, @protocol(JSExport))) {
            continue;
        }

        NSArray *array = @[@(YES), @(NO)];

        NSLog(@"以下协议中部分方法未实现");
        for (NSObject *obj in array) {
            uint pmethodCount;
            struct objc_method_description * pmethodList = protocol_copyMethodDescriptionList(proto, [(NSNumber *)obj boolValue], YES, &pmethodCount);


            for (uint pindex=0; pindex<pmethodCount; pindex++) {
                struct objc_method_description methodDes = pmethodList[pindex];
                if (class_respondsToSelector(theClass, methodDes.name)) {
                    continue;
                }

                NSString *methodName = [NSStringFromSelector(methodDes.name) componentsSeparatedByString:@":"].firstObject;

                Method classMethod = class_getInstanceMethod(theClass, NSSelectorFromString([methodMap valueForKey:methodName]));
                struct objc_method_description *classMethodDes = method_getDescription(classMethod);

                if ((strcmp(classMethodDes->types, methodDes.types) == 0)) {
                    NSLog(@"Protocol:%@ Name:%@ Types:%s", NSStringFromProtocol(proto), NSStringFromSelector(methodDes.name), methodDes.types);
                    if (class_addMethod(theClass, methodDes.name, class_getMethodImplementation(theClass, classMethodDes->name), methodDes.types)) {
                        NSLog(@"Add Method For Name:%@ Types:%s Success", NSStringFromSelector(methodDes.name), methodDes.types);
                    }
                }
            }
        }
    }

    NSLog(@"--------------------------------");

}

+ (Class)classWithModuleName:(NSString *)moduleName{
    Class class = tHybridModelMap[moduleName];
    return class;
}

@end
