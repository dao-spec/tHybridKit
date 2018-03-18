//
//  NSObject+ModuleMap.h
//  tHybridKit
//
//  Created by Dao on 2018/3/16.
//

#import <Foundation/Foundation.h>


/**
 *  用于Web加载Module的Category
 *      
 */
@interface NSObject (ModuleMap)

/**
 *  该方法返回Module所提供的API(For Web) Map.
 *  Method在Map中以NSBlock类型进行存储.
 *  Map中以为Method Name首个':'前的字符串作为Key(及Web中的API名).
 *  Web中使用Module.API(...)进行Native方法的调用.
 *
 *  @return Module的方法Map
 */
- (NSMutableDictionary *)webModuleFuctionMap;

@end
