//
//  TCMWeexImageLoader.m
//  Weex
//
//  Created by Dao on 2017/12/29.
//  Copyright © 2017年 Taocaimall. All rights reserved.
//

#import "TCMWeexImageLoader.h"
#import <SDWebImage/SDWebImageManager.h>


@interface NSString (URL)
/**获取string对应的图片[限本地图片]*/
- (nullable UIImage *)wxImage;
/**获取string对应的URL*/
- (nullable NSURL *)wxURL;

@end

@implementation NSString (URL)
- (nullable UIImage *)wxImage{
    if ([self hasPrefix:@"file://"]) {
        UIImage *image = [UIImage imageNamed:[self substringFromIndex:7]];
        return image;
    }
    return nil;
}
- (nullable NSURL *)wxURL{
    if ([self hasPrefix:@"https://"] || [self hasPrefix:@"http://"]) {
        return [NSURL URLWithString:self];
    }
    return nil;
}
@end


@interface TCMWeexImageLoader() <WXImageOperationProtocol>

@end

@implementation TCMWeexImageLoader
- (void)cancel {
}

- (id<WXImageOperationProtocol>)downloadImageWithURL:(NSString *)url imageFrame:(CGRect)imageFrame userInfo:(NSDictionary *)options completed:(void (^)(UIImage *, NSError *, BOOL))completedBlock {

    UIImage *image = url.wxImage;
    if (image) {
        completedBlock(image, nil, YES);
        return (id<WXImageOperationProtocol>)self;
    }

    return (id<WXImageOperationProtocol>)
    [[SDWebImageManager sharedManager] loadImageWithURL:url.wxURL options:(0) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        completedBlock(image, error, finished);
    }];
}

@end
