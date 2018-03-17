//
//  UIViewController+WebDelegate.m
//  Expecta
//
//  Created by Dao on 2018/2/11.
//

#import "UIViewController+WebDelegate.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "tHybridModelsLoader.h"

#import <NSURL+tHybrid.h>

@implementation UIViewController (WebDelegate)

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //获取请去URL
    NSString *url = request.URL.absoluteString;
    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *requestURL = [NSURL URLWithString:url];
    //是否为移动端(API)业务请求
    if (![requestURL tcmAPP]) {

        return YES;
    }


    return NO;
}


/****************************************************************/
/*                                                              */
/*                      为window.top添加方法                      */
/*                                                              */
/****************************************************************/

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    JSContext *context  =[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.webInstance.webView = webView;
    self.webInstance.jsContext = context;

    context[@"console"][@"log"] = ^(JSValue * msg) {
        NSLog(@"H5  log : %@", msg);
    };
    context[@"console"][@"warn"] = ^(JSValue * msg) {
        NSLog(@"H5  warn : %@", msg);
    };
    context[@"console"][@"error"] = ^(JSValue * msg) {
        NSLog(@"H5  error : %@", msg);
    };


    NSArray *requiredModels = [self arrayForRequiredModels];

    for (NSString *moduleName in requiredModels) {
        if ([self.webInstance.modules valueForKey:moduleName]) {
            continue;
        }
        Class moduleClass = [tHybridModelsLoader classWithModuleName:moduleName];

        NSObject<tHybridWebModuleProtocol,JSExport> *moduleInstance = [[moduleClass alloc] init];
        moduleInstance.webInstance = self.webInstance;

        context[moduleName] = [moduleInstance webModuleFuctionMap];
        [self.webInstance.modules setValue:moduleInstance forKey:moduleName];
    }


}


/**
 *  通用方法
 *
 *  @param data Web转发的数据
 */
- (NSDictionary *)WebRouteMethod:(NSArray *)data{


    NSString *moduleName = nil;
    NSString *eventName = nil;
    NSString *callback = nil;
    NSArray *args = nil;

    if (data.count <= 1) {
        return @{
                 @"info":@"参数错误",
                 @"code":@"-1",
                 };
    }

    //moduleName | eventName
    if (data.count == 2) {
        moduleName = data[0];
        eventName = data[1];
    } else if (data.count == 3) {
        // moduleName | eventName | callback
        moduleName = data[0];
        eventName = data[1];
        callback = data[2];
    } else {

        // moduleName | eventName | callback | args....
        moduleName = data[0];
        eventName = data[1];
        callback = data[2];
        args = [data subarrayWithRange:NSMakeRange(3, data.count-3)];
    }

    //事件名校验
    if (!eventName.length) {
        return nil;
    }
    
//    tHybridSpringRoute *spring = [tHybridSpringRoute getOneTHybridSpringRouteObejct];
//    spring.webInstance = self.webInstance;
//    //回调校验:支持回调的异步调用+返回值，不支持的仅返回值
//    if (callback.length) {
//        return [spring tHybirdInvokeEvent:moduleName eventName:eventName eventSource:(tHybridSpringEventSourceWeb) data:data callback:^(id result, BOOL keepAlive) {
//            //回调Web
//            [self.webInstance.webView stringByEvaluatingJavaScriptFromString:@""];
//        }];
//    } else {
//        return [spring tHybirdInvokeEvent:moduleName eventName:eventName eventSource:(tHybridSpringEventSourceWeb) data:data callback:nil];
//    }
    return nil;
}

- (NSArray *)arrayForRequiredModels{
    return @[tHybridUniversalEventAgentModuleName];
}

@end



