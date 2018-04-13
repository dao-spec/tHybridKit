//
//  UIViewController+WebDelegate.m
//  Expecta
//
//  Created by Dao on 2018/2/11.
//

#import "UIViewController+WebDelegate.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "tHybridModulesLoader.h"

#import "NSURL+tHybrid.h"

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
- (void)webViewDidStartLoad:(UIWebView *)webView{
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


    NSObject<tHybridWebModuleProtocol> *moduleInstance = [[tHybridModulesLoaderHelper alloc] init];
    moduleInstance.webInstance = self.webInstance;

    context[@"weex"] = [moduleInstance webModuleFuctionMap];
    [self.webInstance.modules setValue:moduleInstance forKey:@"tHybridModulesLoaderHelper"];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{



}

- (NSArray *)arrayForRequiredModules{
    return @[tHybridUniversalEventAgentModuleName];
}

@end



