//
//  UIViewController+WebDelegate.h
//  Expecta
//
//  Created by Dao on 2018/2/11.
//

#import <UIKit/UIKit.h>

#import "tHybridSpringReceiveProtocol.h"
#import "tHybridWebProtocol.h"

#import "tHybridUniversalEventModel.h"

@interface UIViewController (WebDelegate)<UIWebViewDelegate, tHybridWebProtocol, tHybridSpringReceiveProtocol>


/**
 *  UIWebViewDelegate协议方法
 *
 *  @param webView Web实例对象
 *  @param request Web实例发出的请求
 *  @param navigationType 见UIWebViewNavigationType的定义
 * @return 是否允许加载
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType NS_REQUIRES_SUPER;


/**
 *  UIWebViewDelegate协议方法
 *
 *  @param webView WebView
 *
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView NS_REQUIRES_SUPER;


- (void)loadRequestURL:(NSString *)url web:(UIWebView *)web;
@end
