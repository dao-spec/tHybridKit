//
//  tHybridWebInstance.h
//  tHybridKit
//
//  Created by Dao on 2018/3/12.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

/**
 * 用于保存Web运行环境的实例
 */
@interface tHybridWebInstance : NSObject

/**
 * Web所依附的控制器
 */
@property (nonatomic, weak) UIViewController *viewController;

/**
 * Web对象
 */
@property (nonatomic, weak) UIWebView *webView;

/**
 * JavaScript运行环境
 */
@property (nonatomic, readonly) JSContext *jsContext;


/**
 * Web中使用到的Modules
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *,NSObject *> *modules;

@end
