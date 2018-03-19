//
//  NSObject+ModuleMap.m
//  tHybridKit
//
//  Created by Dao on 2018/3/16.
//

#import "NSObject+ModuleMap.h"

#import <objc/runtime.h>
#import <objc/message.h>


#import "WXSDKInstance.h"
#import "WXMonitor.h"
#import "WXAssert.h"
#import "WXUtility.h"
#import "WXSDKManager.h"
#import "WXConvert.h"
#import "JSValue+Weex.h"

@interface NSObject ()


/**
 *  <MethodShortName,MethodName>
 *    eg.<setMethodShortName,setMethodShortName:>
 */
@property (nonatomic, copy) NSMutableDictionary *methodMap;

@end

@implementation NSObject (ModuleMap)


/**
 *  该方法返回Module所提供的API(For Web) Map.
 *  Method在Map中以NSBlock类型进行存储.
 *  Map中以为Method Name首个':'前的字符串作为Key(及Web中的API名).
 *  Web中使用Module.API(...)进行Native方法的调用.
 *
 *  @return Module的方法Map
 */
- (NSMutableDictionary *)webModuleFuctionMap{

    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    NSMutableDictionary *methodMap = [NSMutableDictionary dictionary];

    uint outCount;
    Method *claMethodList = class_copyMethodList(object_getClass(self.class), &outCount);

    for (int index=0; index < outCount; index++) {
        Method claMethod = claMethodList[index];

        NSString *claMethodName = NSStringFromSelector(method_getName(claMethod));
        if ([claMethodName hasPrefix:@"thybrid_export_method_"] || [claMethodName hasPrefix:@"thybrid_export_method_sync"]) {
            SEL claSelector = method_getName(claMethod);

            NSInvocation *claInvocation = [NSObject invocationWithTarget:self.class selector:claSelector arguments:nil];
            [claInvocation invoke];
            void *retrunValue;
            [claInvocation getReturnValue:&retrunValue];

            NSString *methodName = [(__bridge id)retrunValue copy];
            NSString *methodShortKey = [methodName componentsSeparatedByString:@":"].firstObject;

            [methodMap setValue:methodName forKey:methodShortKey];

            __weak typeof(self) weakSelf = self;
            map[methodShortKey] = [^(){
                __strong typeof(weakSelf) strongSelf= weakSelf;
                NSArray *array = [JSContext currentArguments];
                JSValue *this = [JSContext currentThis];
                NSString *shortKey = [[this toObject] allKeys].firstObject;

                NSInvocation *invocation = [NSObject invocationWithTarget:strongSelf selector:[strongSelf selectorWithMethodShortKey:shortKey] arguments:array];
                JSValue *returnValue = nil;
                //同步
                if (invocation) {
                    [invocation invoke];
                    if ([claMethodName hasPrefix:@"thybrid_export_method_sync"]) {
                        returnValue = [JSValue wx_valueWithReturnValueFromInvocation:invocation inContext:[JSContext currentContext]];
                    }
                }
                return returnValue;
            } copy];
        }
    }

    free(claMethodList);

    self.methodMap = methodMap;
    //方法扫描，确认H5方法

    return map;
}


/**
 *  返回一个NSInvocation类型的Instance.
 *  参数arguments是一个NSArray<JSValue *>类型的数组;
 *  JSValue类型的Instance无法直接转换为NSBlock类型;
 *
 *  @param target Target Object
 *  @param selector selector
 *  @param arguments arguments
 *  @return NSInvication instance
 */
+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector arguments:(NSArray *)arguments{
    WXAssert(target, @"No target for method:%@", self);
    WXAssert(selector, @"No selector for method:%@", self);

    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (!signature) {
        NSString *errorMessage = [NSString stringWithFormat:@"target:%@, selector:%@ doesn't have a method signature", target, NSStringFromSelector(selector)];
        WX_MONITOR_FAIL(WXMTJSBridge, WX_ERR_INVOKE_NATIVE, errorMessage);
        return nil;
    }

    if (signature.numberOfArguments - 2 < arguments.count) {
        NSString *errorMessage = [NSString stringWithFormat:@"%@, the parameters in calling method [%@] and registered method [%@] are not consistent！", target, NSStringFromSelector(selector), NSStringFromSelector(selector)];
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
        JSValue *arg = arguments[i];
        const char *parameterType = [signature getArgumentTypeAtIndex:i + 2];
        id obj = [self parseArgument:[arg toObject] parameterType:parameterType order:i];
        static const char *blockType = @encode(typeof(^{}));
        id argument;
        if (!strcmp(parameterType, blockType)) {
            // callback
            argument = [^void(NSString *result, BOOL keepAlive) {
                [arg callWithArguments:@[result]];
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


/**
 *  JavaScript调用Native的参数解析
 *
 *  @param obj Obejctive-C Instance
 *  @param parameterType Native中定义的参数类型
 *  @param order 方法中参数Index
 *  @return Native中方法所定义的参数类型的数据
 */
+ (id)parseArgument:(id)obj parameterType:(const char *)parameterType order:(int)order{
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

static void* kMethodMap = &kMethodMap;
- (void)setMethodMap:(NSMutableDictionary *)methodMap{
    objc_setAssociatedObject(self, &kMethodMap, methodMap, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableDictionary *)methodMap{
    NSMutableDictionary *map = objc_getAssociatedObject(self, &kMethodMap);
    return map;
}


/**
 * 按照MethodShortName返回对应的SEL类型的数据
 *
 * @param shortKey MethodShortName
 * @return MethodName对应的SEL数据
 */
- (SEL)selectorWithMethodShortKey:(NSString *)shortKey{

    NSString *methodName = [self.methodMap valueForKey:shortKey];
    SEL selector = NSSelectorFromString(methodName);

    return selector;
}

@end
