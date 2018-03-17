//
//  NSObject+ModuleMap.m
//  tHybridKit
//
//  Created by Dao on 2018/3/16.
//

#import "NSObject+ModuleMap.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import <objc/message.h>


#import "WXSDKInstance.h"
#import "WXMonitor.h"
#import "WXAssert.h"
#import "WXUtility.h"
#import "WXSDKManager.h"
#import <objc/runtime.h>
#import "WXConvert.h"


@implementation NSObject (ModuleMap)

- (NSMutableDictionary *)webModuleFuctionMap{

    NSMutableDictionary *map = [NSMutableDictionary dictionary];


    uint outCount;
    Method *methodList = class_copyMethodList(object_getClass(self.class), &outCount);


    for (int index=0; index < outCount; index++) {
        Method method = methodList[index];

        NSString *methodName = NSStringFromSelector(method_getName(method));
        if ([methodName hasPrefix:@"thybrid_export_method_"] || [methodName hasPrefix:@"thybrid_export_method_sync"]) {
            SEL selector = method_getName(method);

            NSString *methodName = (NSString *)[self.class performSelector:selector withObject:nil];
            map[[methodName componentsSeparatedByString:@":"].firstObject] = ^(){
                NSArray *array = [JSContext currentArguments];

                NSMutableArray *args = [NSMutableArray array];

                for (uint index=0; index < array.count; index++) {
                    id obj = [array[index] toObject];
                    [args addObject:obj];
                }

                SEL IMP_selector = NSSelectorFromString(methodName);

                NSInvocation *invocation = [self invocationWithTarget:self selector:IMP_selector arguments:args methodName:methodName callback:array.lastObject];
                if (invocation) {
                    [invocation invoke];
                }
            };
        }
    }

    free(methodList);

    //方法扫描，确认H5方法

    return map;
}

- (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector arguments:(NSArray *)arguments methodName:(NSString *)methodName callback:(JSValue *)callback{
    WXAssert(target, @"No target for method:%@", self);
    WXAssert(selector, @"No selector for method:%@", self);

    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (!signature) {
        NSString *errorMessage = [NSString stringWithFormat:@"target:%@, selector:%@ doesn't have a method signature", target, NSStringFromSelector(selector)];
        WX_MONITOR_FAIL(WXMTJSBridge, WX_ERR_INVOKE_NATIVE, errorMessage);
        return nil;
    }

    if (signature.numberOfArguments - 2 < arguments.count) {
        NSString *errorMessage = [NSString stringWithFormat:@"%@, the parameters in calling method [%@] and registered method [%@] are not consistent！", target, methodName, NSStringFromSelector(selector)];
        WX_MONITOR_FAIL(WXMTJSBridge, WX_ERR_INVOKE_NATIVE, errorMessage);
        return nil;
    }

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    void **freeList = NULL;

    NSMutableArray *blockArray = [NSMutableArray array];
    WX_ALLOC_FLIST(freeList, arguments.count);
    for (int i = 0; i < arguments.count; i ++ ) {
        id obj = arguments[i];
        const char *parameterType = [signature getArgumentTypeAtIndex:i + 2];
        obj = [self parseArgument:obj parameterType:parameterType order:i];
        static const char *blockType = @encode(typeof(^{}));
        id argument;
        if (!strcmp(parameterType, blockType)) {
            // callback
            argument = [^void(NSString *result, BOOL keepAlive) {
                [callback callWithArguments:@[result]];
            } copy];

            // retain block
            [blockArray addObject:argument];
            [invocation setArgument:&argument atIndex:i + 2];
        } else {
            argument = obj;
            WX_ARGUMENTS_SET(invocation, signature, i, argument, freeList);
        }
    }
    [invocation retainArguments];
    WX_FREE_FLIST(freeList, arguments.count);

    return invocation;
}

-(id)parseArgument:(id)obj parameterType:(const char *)parameterType order:(int)order{
#ifdef DEBUG
    BOOL check = YES;
#endif
    if (strcmp(parameterType,@encode(float))==0 || strcmp(parameterType,@encode(double))==0)
    {
#ifdef DEBUG
        check =  [obj isKindOfClass:[NSNumber class]];
        if(!check){
//            NSLog(@"<%@: %p; instance = %@; method = %@; arguments= %@; the number %d parameter type is not right,it should be float or double>",NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments,order);
        }
#endif
        CGFloat value = [WXConvert CGFloat:obj];
        return [NSNumber numberWithDouble:value];
    } else if (strcmp(parameterType,@encode(int))==0) {
#ifdef DEBUG
        check =  [obj isKindOfClass:[NSNumber class]];
        if(!check){
//            NSLog(@"<%@: %p; instance = %@; method = %@; arguments= %@; the number %d parameter type is not right,it should be int>",NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments,order);
        }
#endif
        NSInteger value = [WXConvert NSInteger:obj];
        return [NSNumber numberWithInteger:value];
    } else if(strcmp(parameterType,@encode(id))==0) {
#ifdef DEBUG
        check =  [obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]] ||[obj isKindOfClass:[NSString class]];
        if(!check){
//            NSLog(@"<%@: %p; instance = %@; method = %@; arguments= %@ ;the number %d parameter type is not right,it should be array ,map or string>",NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments,order);
        }
#endif
        return obj;
    } else if(strcmp(parameterType,@encode(typeof(^{})))==0) {
#ifdef DEBUG
        check =  [obj isKindOfClass:[NSString class]]; // jsfm pass string if parameter type is block
        if(!check){
//            NSLog(@"<%@: %p; instance = %@; method = %@; arguments= %@; the number %d parameter type is not right,it should be block>",NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments,order);
        }
#endif
        return obj;
    }
    return obj;
}


@end
