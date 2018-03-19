//
//  NSObject+tHybridURL.h
//  tHybridKit
//
//  Created by Dao on 2018/3/14.
//

#import <Foundation/Foundation.h>

@interface NSObject (tHybridRemoteBaseURL)


/**
 * 获取APP支持的远程服务器地址
 *
 * @return 远程服务器地址
 */
- (NSString *)tHybridRemoteBaseURL;

/**
 * 获取APP支持的远程服务器地址
 *
 * @return 远程服务器地址
 */
+ (NSString *)tHybridRemoteBaseURL;

@end
