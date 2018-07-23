//
//  tHybridSpringReceiveProtocol.h
//  AFNetworking
//
//  Created by Dao on 2018/2/9.
//

#import <Foundation/Foundation.h>

#import "WXModuleProtocol.h"
#import "tHybridUniversalEventModel.h"


/**
 * 接收Module事件转发的Protocol
 */
@protocol tHybridSpringReceiveProtocol <NSObject>

/**
 *  通过weexInstance向ViewController续传事件
 *      ⚠️该线程不可直接执行UI相关的操作
 */
@optional
- (void)responsetHybridUniversalEventModel:(tHybridUniversalEventModel *)event;


@end


