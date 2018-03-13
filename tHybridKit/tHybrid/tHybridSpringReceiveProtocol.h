//
//  tHybridSpringReceiveProtocol.h
//  AFNetworking
//
//  Created by Dao on 2018/2/9.
//

#import <Foundation/Foundation.h>

#import "WXModuleProtocol.h"
#import "tHybridEvent.h"

typedef NS_ENUM(NSUInteger, tHybridSpringEventSource) {
    tHybridSpringEventSourceNative,
    tHybridSpringEventSourceWeex,
    tHybridSpringEventSourceWeb,
    tHybridSpringEventSourceBrowser,
};



@protocol tHybridSpringReceiveProtocol <NSObject>

/**
 *  通过weexInstance向ViewController续传事件
 *      ⚠️该线程不可直接执行UI相关的操作
 */
@optional
- (id)responseTHybridEvent:(tHybridEvent *)event;


@end


