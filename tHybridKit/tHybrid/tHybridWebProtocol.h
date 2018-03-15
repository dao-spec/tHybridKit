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

@optional
- (NSArray *)arrayForRequiredModels;


@end



@protocol tHybridWebModuleProtocol <NSObject>

@property (nonatomic, weak) tHybridWebInstance *webInstance;

@end
