//
//  NSURL+tHybrid.h
//  Weex
//
//  Created by Dao on 2018/1/29.
//  Copyright © 2018年 Taocaimall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol thybridURL <NSObject>

+ (NSURL *)weexUrlWithFilePath:(NSString *)filePath;

@end


/**
 *  用于拦截由Web发出的请求，分割为请求API(tcmRequest)和请求数据(tcmRequest)
 *      tcmRequest 为预定的业务标识
 *      tcmRequest 为业务处理所需的参数[key-value]
 */
@interface NSURL (tHybrid) <thybridURL>

/**
 * 从请求中解析的请求类型
 */
@property (nonatomic, copy, readonly) NSString *tcmRequest;

/**
 * 从请求中解析的请求数据
 */
@property (nonatomic, copy, readonly) NSDictionary *tcmRequestData;


/**
 *  请求是否为APP业务
 */
@property (nonatomic, assign, readonly) BOOL tcmAPP;


@end
