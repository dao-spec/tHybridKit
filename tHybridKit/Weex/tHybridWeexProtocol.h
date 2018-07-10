//
//  tHybridWeexProtocol.h
//  AFNetworking
//
//  Created by Dao on 2018/2/9.
//

#import "WXSDKInstance.h"

typedef NS_OPTIONS(NSUInteger, thybridRenderOption) {
    thybridRenderOptionUnknown = 1 << 0,
    thybridRenderOptionOnRendering = 1 << 1,
    thybridRenderOptionOnFail = 1 << 2,
    thybridRenderOptionOnCreate = 1 << 3,
    thybridRenderOptionOnFinish = 1 << 4,
};

/**
 * Weex使用规范
 *  遵循协议后，使用关键字synthesize
 */
@protocol tHybridWeexProtocol <NSObject>

@required
@property (nonatomic, strong) WXSDKInstance *weexInstance;
@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, strong) NSURL *weexUrl;
@property (nonatomic, strong) __kindof NSObject *options;
@property (nonatomic, assign) thybridRenderOption renderOption;
@property (nonatomic, weak) UIView *contentView;

@required
- (void)onCreate:(UIView *)view;

@optional
- (void)onFailed:(NSError *)error;

@optional
- (void)renderFinish:(UIView *)view;

@end
