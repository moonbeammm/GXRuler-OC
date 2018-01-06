//
//  GXApiModelDescription.h
//  GXNetwork
//
//  Created by sunguangxin on 2017/10/20.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXApiModelDescription : NSObject

/// keyPath是对象在JSON数据中的层级路径
/// 如: @"/data/recommands/list" 表示{"data":{"recommands":{"list":(可以是: 数字; "字符串"; bool; [数组]; {字典};)}}}
/// 注意: 如果想取根级json keyPath需等于"/"
@property(nonatomic, strong) NSString   *keyPath;

/// keyPath获取的是否是NSArray类型集合对象 (仅区分是单个对象还是数组类型对象)
@property(nonatomic, assign) BOOL       isArray;

/// 对于NSArray集合对象mappingClass表明每个元素的解析类,
/// 对于非NSArray集合对象mappingClass表明keyPath元素的解析类
/// 当前仅支持: 用户自定义类; NSDictionary; SKVObject; NSNumber; NSString;
@property(nonatomic, strong) Class      mappingClass;

/// 是否是接口返回数据必须提供的字段
@property(nonatomic, assign) BOOL       isOptional;

+ (instancetype)modelWith:(NSString *)keyPath mappingClass:(Class)mappingClass isArray:(BOOL)isArray;

+ (instancetype)modelWith:(NSString *)keyPath mappingClass:(Class)mappingClass isArray:(BOOL)isArray isOptional:(BOOL)isOption;


@end
