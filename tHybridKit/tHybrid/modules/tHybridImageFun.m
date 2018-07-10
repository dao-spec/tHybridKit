//
//  tHybridImageFun.m
//  DTCoreText
//
//  Created by Dao on 2018/6/29.
//

#import "tHybridImageFun.h"


@implementation tHybridImageFun

@synthesize webInstance;
@synthesize weexInstance;

WX_EXPORT_METHOD_SYNC(@selector(size:));
- (NSDictionary *)size:(NSString *)url{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            return @{
                     @"width":@(image.size.width).stringValue,
                     @"height":@(image.size.height).stringValue
                     };
        }
    }
    return @{
             @"width":@"0",
             @"height":@"0"
             };
}

@end
