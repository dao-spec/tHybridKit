//
//  UIViewController+Browser.h
//  tHybridKit
//
//  Created by Dao on 2018/3/7.
//

#import <UIKit/UIKit.h>



/**
 *  响应由浏览器发起的请求
 *
 */
@interface UIViewController (Browser)

- (BOOL)respondsBrowserRequest:(NSURL *)url;

@end
