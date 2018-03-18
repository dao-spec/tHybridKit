//
//  TCMWeexImageLoader.h
//  Weex
//
//  Created by Dao on 2017/12/29.
//  Copyright © 2017年 Taocaimall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeexSDK/WeexSDK.h"

/**
 功能描述:
     实现图片加载功能(Weex本身只提供UI渲染，不提供能力支持)
 */
@interface TCMWeexImageLoader : NSObject <WXImgLoaderProtocol>

@end
