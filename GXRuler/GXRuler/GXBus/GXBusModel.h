//
//  GXBusModel.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  总线数据模型，用来保证数据合法性，保证其满足协议需求
 *  除了GXCore工程中存在的GXBusModel子类，其他子类会导致验证失效
 */
@class GXBusValidator;
@interface GXBusModel : NSObject


@property (nonatomic, strong, readonly) NSDictionary *valueTypeDict; // 值类型字典

@property (nonatomic, strong) id unsafeUserInfo; // 用户自定义数据，慎用

- (BOOL)hasValueForKey:(NSString *)key;

#pragma mark - Setter
/**
 *  增加一个Long型值
 *
 *  @param value 要增加的值
 *  @param key 对应主键
 */
- (void)setLongValue:(int64_t)value forKey:(NSString *)key;

/**
 *  增加一个Double型值
 *
 *  @param value 要增加的值
 *  @param key 对应主键
 */
- (void)setDoubleValue:(double)value forKey:(NSString *)key;

/**
 *  增加一个String型值
 *
 *  @param value 要增加的值
 *  @param key 对应主键
 */
- (void)setStringValue:(NSString *)value forKey:(NSString *)key;

/**
 *  增加一个总线数据模型值
 *
 *  @param value 要增加的值
 *  @param key 对应主键
 */
- (void)setModelValue:(GXBusModel *)value forKey:(NSString *)key;

/**
 *  增加一个Long型数组值
 *
 *  @param value 要增加的值
 *  @param key 对应主键
 */
- (void)setLongArrayValue:(NSArray *)value forKey:(NSString *)key;

/**
 *  增加一个Double型数组值
 *
 *  @param value 要增加的值
 *  @param key 对应主键
 */
- (void)setDoubleArrayValue:(NSArray *)value forKey:(NSString *)key;

/**
 *  增加一个String型数组值
 *
 *  @param value 要增加的值
 *  @param key 对应主键
 */
- (void)setStringArrayValue:(NSArray *)value forKey:(NSString *)key;

/**
 *  增加一个总线数据模型数组值
 *
 *  @param value 要增加的值
 *  @param key 对应主键
 */
- (void)setModelArrayValue:(NSArray *)value forKey:(NSString *)key;

/**
 *  增加一个VC值
 *
 *  @param value 要增加的值
 *  @param key 对应主键
 */
- (void)setControllerValue:(UIViewController *)value forKey:(NSString *)key;

/**
 *  增加一个View值
 *
 *  @param value 要增加的值
 *  @param key 对应主键
 */
- (void)setViewValue:(UIView *)value forKey:(NSString *)key;

/**
 *  增加一个ViewModel值
 *
 *  @param value 要增加的值
 *  @param key 对应主键
 */
- (void)setViewModelValue:(id)value forKey:(NSString *)key;

#pragma mark - Getter
/**
 *  获得一个Long型值
 *
 *  @param key 对应主键
 *
 *  @preturn 所取得的值，类型不匹配时会返回0
 */
- (int64_t)longValueForKey:(NSString *)key;

/**
 *  获得一个Double型值
 *
 *  @param key 对应主键
 *
 *  @preturn 所取得的值，类型不匹配时会返回0
 */
- (double)doubleValueForKey:(NSString *)key;

/**
 *  获得一个String型值
 *
 *  @param key 对应主键
 *
 *  @preturn 所取得的值，类型不匹配时会返回nil
 */
- (NSString *)stringValueForKey:(NSString *)key;

/**
 *  获得一个总线数据模型值
 *
 *  @param key 对应主键
 *
 *  @preturn 所取得的值，类型不匹配时会返回nil
 */
- (GXBusModel *)modelValueForKey:(NSString *)key;

/**
 *  获得一个Long型数组值
 *
 *  @param key 对应主键
 *
 *  @preturn 所取得的值，类型不匹配时会返回nil
 */
- (NSArray *)longArrayValueForKey:(NSString *)key;

/**
 *  获得一个Double型数组值
 *
 *  @param key 对应主键
 *
 *  @preturn 所取得的值，类型不匹配时会返回nil
 */
- (NSArray *)doubleArrayValueForKey:(NSString *)key;

/**
 *  获得一个String型数组值
 *
 *  @param key 对应主键
 *
 *  @preturn 所取得的值，类型不匹配时会返回nil
 */
- (NSArray *)stringArrayValueForKey:(NSString *)key;

/**
 *  获得一个总线数据模型数组值
 *
 *  @param key 对应主键
 *
 *  @preturn 所取得的值，类型不匹配时会返回nil
 */
- (NSArray *)modelArrayValueForKey:(NSString *)key;

/**
 *  获得一个VC值
 *
 *  @param key 对应主键
 *
 *  @preturn 所取得的值，类型不匹配时会返回nil
 */
- (UIViewController *)controllerValueForKey:(NSString *)key;

/**
 *  获得一个View值
 *
 *  @param key 对应主键
 *
 *  @preturn 所取得的值，类型不匹配时会返回nil
 */
- (UIView *)viewValueForKey:(NSString *)key;

/**
 *  获得一个ViewModel值
 *
 *  @param key 对应主键
 *
 *  @preturn 所取得的值，类型不匹配时会返回nil
 */
- (id)viewModelValueForKey:(NSString *)key;

@end
