//
//  tHybridWebProtocol.h
//  tHybridKit
//
//  Created by Dao on 2018/3/12.
//

#import <Foundation/Foundation.h>
#import <tHybridWebInstance.h>

@protocol tHybridWebProtocol <NSObject>

@required
@property (nonatomic, strong) tHybridWebInstance *webInstance;

@end

@protocol tHybridMoudleProtocol <NSObject>

@property (nonatomic, weak) tHybridWebInstance *webInstance;

@end
