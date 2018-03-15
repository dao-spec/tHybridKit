//
//  TCMWeex.m
//  Weex
//
//  Created by Dao on 2018/1/9.
//  Copyright © 2018年 Taocaimall. All rights reserved.
//

#import "TCMWeex.h"

#import "WeexSDK.h"
#import "TCMWeexImageLoader.h"
#import "tHybridModelsLoader.h"

@implementation tHybridKit

+ (void)launchingWeex{
    [WXLog setLogLevel:WXLogLevelAll];

    [WXAppConfiguration setAppGroup:@"Taocaimall"];
    [WXAppConfiguration setAppName:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey]];

    [WXAppConfiguration setAppVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];

    //初始化环境
    [WXSDKEngine initSDKEnvironment];

    //注册图片加载器
    [WXSDKEngine registerHandler:[TCMWeexImageLoader new] withProtocol:@protocol(WXImgLoaderProtocol)];

    //注册Model
    [tHybridModelsLoader loadModels:^(__unsafe_unretained Class modelClass, NSString *modelName) {
        [WXSDKEngine registerModule:modelName withClass:modelClass];
    }];
}


@end
