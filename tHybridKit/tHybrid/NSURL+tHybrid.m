//
//  NSURL+tHybrid.m
//  Weex
//
//  Created by Dao on 2018/1/29.
//  Copyright © 2018年 Taocaimall. All rights reserved.
//

#import "NSURL+tHybrid.h"
#import <objc/runtime.h>

static NSString* kRequest = @"tcmRequest";
static NSString* kRequestData = @"tcmRequestData";

NSString  *scheme = @"taocaimall";


@implementation NSURL (tHybrid)

- (NSString *)tcmRequest{
    if (!objc_getAssociatedObject(self, &kRequest)) {
        NSString *absoluteString = [self.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSArray *array = [absoluteString componentsSeparatedByString:@"?"];
        if (array.firstObject) {
            objc_setAssociatedObject(self, &kRequest, array.firstObject, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
    }
    return objc_getAssociatedObject(self, &kRequest);
}


- (NSDictionary *)tcmRequestData{
    if (!objc_getAssociatedObject(self, &kRequestData)) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        NSString *absoluteString = [self.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSArray *keyValues = [absoluteString componentsSeparatedByString:@"&"];
        for (NSString *kvp in keyValues) {
            NSArray *kvs = [kvp componentsSeparatedByString:@"=" ];
            if (kvs.count == 2) {
                [dic setValue:kvs.lastObject forKey:kvs.firstObject];
            } else {
                [dic setValue:@"" forKey:kvs.firstObject];
            }
        }
        objc_setAssociatedObject(self, &kRequestData, dic, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return objc_getAssociatedObject(self, &kRequestData);
}


- (BOOL)tcmAPP{
    if ([self.scheme isEqualToString:scheme]) {
        return YES;
    }
    return NO;
}


@end



