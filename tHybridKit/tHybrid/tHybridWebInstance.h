//
//  tHybridWebInstance.h
//  tHybridKit
//
//  Created by Dao on 2018/3/12.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


@interface tHybridWebInstance : NSObject

/**
 * The viewControler which the weex bundle is rendered in.
 **/
@property (nonatomic, weak) UIViewController *viewController;
/**
 * The viewControler which the weex bundle is rendered in.
 **/
@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, weak) JSContext *jsContext;

@property (nonatomic, strong) NSMutableDictionary<NSString *,NSObject<JSExport> *> *modules;

@property (nonatomic, strong) NSObject<JSExport> *module;

@end
