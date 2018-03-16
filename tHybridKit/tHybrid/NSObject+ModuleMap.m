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

#define WX_ENUMBER_CASE(_invoke, idx, code, obj, _type, op, _flist) \
case code:{\
_type *_tmp = malloc(sizeof(_type));\
memset(_tmp, 0, sizeof(_type));\
*_tmp = [obj op];\
[_invoke setArgument:_tmp atIndex:(idx) + 2];\
*(_flist + idx) = _tmp;\
break;\
}
#define WX_EPCHAR_CASE(_invoke, idx, code, obj, _type, op, _flist) \
case code:{\
_type *_tmp = (_type  *)[obj op];\
[_invoke setArgument:&_tmp atIndex:(idx) + 2];\
*(_flist + idx) = 0;\
break;\
}\

#define WX_ALLOC_FLIST(_ppFree, _count) \
do {\
_ppFree = (void *)malloc(sizeof(void *) * (_count));\
memset(_ppFree, 0, sizeof(void *) * (_count));\
} while(0)

#define WX_FREE_FLIST(_ppFree, _count) \
do {\
for(int i = 0; i < _count; i++){\
if(*(_ppFree + i ) != 0) {\
free(*(_ppFree + i));\
}\
}\
free(_ppFree);\
}while(0)

#define WX_ARGUMENTS_SET(_invocation, _sig, idx, _obj, _ppFree) \
do {\
const char *encode = [_sig getArgumentTypeAtIndex:(idx) + 2];\
switch(encode[0]){\
WX_EPCHAR_CASE(_invocation, idx, _C_CHARPTR, _obj, char *, UTF8String, _ppFree)\
WX_ENUMBER_CASE(_invocation, idx, _C_INT, _obj, int, intValue, _ppFree)\
WX_ENUMBER_CASE(_invocation, idx, _C_SHT, _obj, short, shortValue, _ppFree)\
WX_ENUMBER_CASE(_invocation, idx, _C_LNG, _obj, long, longValue, _ppFree)\
WX_ENUMBER_CASE(_invocation, idx, _C_LNG_LNG, _obj, long long, longLongValue, _ppFree)\
WX_ENUMBER_CASE(_invocation, idx, _C_UCHR, _obj, unsigned char, unsignedCharValue, _ppFree)\
WX_ENUMBER_CASE(_invocation, idx, _C_UINT, _obj, unsigned int, unsignedIntValue, _ppFree)\
WX_ENUMBER_CASE(_invocation, idx, _C_USHT, _obj, unsigned short, unsignedShortValue, _ppFree)\
WX_ENUMBER_CASE(_invocation, idx, _C_ULNG, _obj, unsigned long, unsignedLongValue, _ppFree)\
WX_ENUMBER_CASE(_invocation, idx, _C_ULNG_LNG, _obj,unsigned long long, unsignedLongLongValue, _ppFree)\
WX_ENUMBER_CASE(_invocation, idx, _C_FLT, _obj, float, floatValue, _ppFree)\
WX_ENUMBER_CASE(_invocation, idx, _C_DBL, _obj, double, doubleValue, _ppFree)\
WX_ENUMBER_CASE(_invocation, idx, _C_BOOL, _obj, bool, boolValue, _ppFree)\
default: { [_invocation setArgument:&_obj atIndex:(idx) + 2]; *(_ppFree + idx) = 0; break;}\
}\
}while(0)

@implementation NSObject (ModuleMap)

+ (NSMutableDictionary *)webModuleFuctionMap{

    NSMutableDictionary *map = [NSMutableDictionary dictionary];


    uint outCount;
    Method *methodList = class_copyMethodList(object_getClass(self), &outCount);


    for (int index=0; index < outCount; index++) {
        Method method = methodList[index];

        NSString *methodName = NSStringFromSelector(method_getName(method));
        if ([methodName hasPrefix:@"thybrid_export_method_"]) {
            SEL selector = method_getName(method);

            NSString *methodName = (NSString *)[self performSelector:selector withObject:nil];
            map[[methodName componentsSeparatedByString:@":"].firstObject] = ^(){
                NSArray *arrya = [JSContext currentArguments];
                for (NSObject *obj in arrya) {
                    NSLog(@"%@", obj);
                }
            };
        }
    }

    free(methodList);

    //方法扫描，确认H5方法

    return map;
}

@end
