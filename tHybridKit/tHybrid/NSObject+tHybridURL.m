//
//  NSObject+tHybridURL.m
//  tHybridKit
//
//  Created by Dao on 2018/3/14.
//

#import "NSObject+tHybridURL.h"

@implementation NSObject (tHybridRemoteBaseURL)

- (NSString *)tHybridRemoteBaseURL{
    return [NSObject tHybridRemoteBaseURL];
}


+ (NSString *)tHybridRemoteBaseURL{
#if DEBUG
    return @"http://192.168.15.238:8081/dist";
#else
    return @"https://s3.cn-north-1.amazonaws.com.cn/h5.taocai.mobi/down/thybrid/buyer/";
#endif
}

@end
