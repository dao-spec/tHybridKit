//
//  UIViewController+Browser.m
//  tHybridKit
//
//  Created by Dao on 2018/3/7.
//

#import "UIViewController+Browser.h"

#import "NSURL+tHybrid.h"
#import "tHybridUniversalEventModel.h"

@implementation UIViewController (Browser)

- (BOOL)respondsBrowserRequest:(NSURL *)url{

    NSString *request = url.tcmRequest;
    NSDictionary *requestData = url.tcmRequestData;
    
    NSLog(@"%@", request);
    NSLog(@"%@", requestData);


    return YES;
}

@end
