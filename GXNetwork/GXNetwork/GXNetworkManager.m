//
//  GXNetworkManager.m
//  GXNetwork
//
//  Created by sunguangxin on 2017/4/20.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXNetworkManager.h"
#import "GXOperation.h"
#import "GXStringHelper.h"
#import "SKVObject.h"
#import <YYModel/YYModel.h>
#import "GXApiModelProtocol.h"

@interface GXNetworkManager () <GXOperationProtocol>

@property (nonatomic, strong) GXApiOptions *options;
@property (nonatomic, copy) void (^downloadProgress)(NSProgress * _Nullable downloadProgress);
@property (nonatomic, copy) void (^success)(NSDictionary * _Nullable result, NSURLResponse * _Nullable response);
@property (nonatomic, copy) void (^failure)(NSDictionary * _Nullable result, NSError * _Nullable error);

@property (nonatomic, strong) NSThread *currentThread;
// 是否正在请求 (GXNetworkManager并不是单利.所以不会有地方将isRequesting置为NO)
@property (nonatomic, assign) BOOL isRequesting;

@property (nonatomic, strong) GXOperation *operation;
@property (nonatomic, strong) NSString *queryString;

@property (nonatomic, assign) BOOL cancelled;

@end

@implementation GXNetworkManager

#pragma mark - Public Method
- (instancetype _Nullable )initWithOptions:(GXApiOptions *_Nullable)options
                                   success:(nullable void (^)(NSDictionary * _Nullable result, NSURLResponse * _Nullable response))success
                                   failure:(nullable void (^)(NSDictionary * _Nullable result, NSError * _Nullable error))failure
{
    return [self initWithOptions:options progress:nil success:success failure:failure];
}
- (instancetype _Nullable )initWithOptions:(GXApiOptions *_Nullable)options
                                  progress:(nullable void (^)(NSProgress * _Nullable downloadProgress))downloadProgress
                                   success:(nullable void (^)(NSDictionary * _Nullable result, NSURLResponse * _Nullable response))success
                                   failure:(nullable void (^)(NSDictionary * _Nullable result, NSError * _Nullable error))failure
{
    if (self = [super init]) {
        self.options = options;
        self.operation = [[GXOperation alloc] init];
        self.operation.delegate = self;
        self.currentThread = [NSThread currentThread];
        self.downloadProgress = downloadProgress;
        self.success = success;
        self.failure = failure;
    }
    return self;
}

/**
 发起异步请求>>>>>1
 */
- (void)requestAsync
{
    NSAssert([NSThread currentThread] == self.currentThread, @"GXNetworkManager requestAsync: Current thread is not the one when request was created");
    if (!self.isRequesting) {
        self.isRequesting = YES;
        [self start:YES];
    } else {
        NSAssert(NO, @"GXNetworkManager requestAsync: Each api has to request only once");
    }
}

/**
 发起同步请求>>>>>1
 */
- (void)requestSync
{

}

/**
 取消请求
 */
- (void)cancel
{
    NSAssert([NSThread currentThread] == _currentThread, @"BFCApiRequest cancel: Current thread is not the one when request was created");
    @synchronized (self) {
        _cancelled = YES;
    }
    [self.operation cancel];
}

- (BOOL)isCancelled {
    NSAssert([NSThread currentThread] == _currentThread, @"BFCApiRequest isCancelled: Current thread is not the one when request was created");
    @synchronized (self) {
        return _cancelled;
    }
}

/**
 给两个请求添加依赖关系
 */
- (void)addDependency
{

}

/**
 取消依赖
 */
- (void)removeDependency
{

}

/**
 清除所有缓存
 */
- (void)cleanCache
{

}

#pragma mark - GXOperationProtocol

- (void)cancelRequest
{
    self.operation = nil;
}

#pragma mark - Private Method

// 开始请求>>>>>>>>>2
- (void)start:(BOOL)immediately
{
    NSAssert(self.options.baseUrl.length, @"GXNetworkManager start: URL is nil");
    
    NSMutableURLRequest *request = [self configureRequest];
    GXOperation *operation = [self configureOperation];
    operation.request = request;
    self.operation = operation;
    [self.operation execute:immediately];
}

#pragma mark - Helper Method

// >>>>>>>>>2.0
- (NSMutableURLRequest *)configureRequest
{
    NSMutableURLRequest *request = nil;
    NSString *queryString = [self queryString];
    switch (self.options.httpMethod) {
        case GXApiHttpMethodTypeGET:
            request = [self GETRequestWithQueryString:queryString];
            break;
        case GXApiHttpMethodTypePUT:
            
            break;
        case GXApiHttpMethodTypePOST:
        {
            
        }
            break;
            
        default:
            break;
    }
    NSDictionary *exHTTPHeader = self.options.exHTTPHeader;
    for (NSString *key in exHTTPHeader) {
        NSString *agent = [exHTTPHeader valueForKey:key];
        [request setValue:agent forHTTPHeaderField:key];
    }
    if (self.options.httpMethod != GXApiHttpMethodTypeGET) {
        NSData *body = [queryString dataUsingEncoding:NSUTF8StringEncoding];
        if (body) {
            request.HTTPBody = body;
        }
    }
    return request;
}
// >>>>>>>>>2.1
- (GXOperation *)configureOperation
{
    GXOperation *operation = self.operation;
    operation.beforeRequestCallback = ^BOOL {
        return YES;
    };
    operation.afterRequestCallback = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (self.success) {
                SKVObject *result = [self _serializationFromRawData:data error:&error];
                NSError *mappedError = nil;
                NSDictionary *mappedResponse = [self _ormResponse:result error:&mappedError];
                self.success(mappedResponse, response);
            }
        } else {
            if (self.failure) {
                self.failure(nil, error);
            }
        }
    };
    return operation;
}

// >>>>>>>>>>>>>2.1.1
- (NSMutableURLRequest *)GETRequestWithQueryString:(NSString *)queryString
{
    NSString *requestUrlString = self.options.baseUrl;
    if ([queryString length]) {
        requestUrlString = [NSString stringWithFormat:@"%@?%@", self.options.baseUrl, queryString];
    }
    NSURL *requestUrl = [[NSURL alloc] initWithString:requestUrlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:self.options.timeoutInterval];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    return request;
}


#pragma mark - params

- (NSString *)queryString
{
    NSMutableDictionary *mutaDic = [NSMutableDictionary dictionary];
    [mutaDic addEntriesFromDictionary:self.options.params];
    return [GXStringHelper getQueryStrWithParams:mutaDic];
}

#pragma mark - 解析字典为model

- (nullable NSDictionary *)_ormResponse:(SKVObject * _Nullable)obj error:(NSError ** _Nonnull)errorPtr
{
    *errorPtr = nil;
    if (!obj || !self.options.modelDescriptions.count) return nil;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:self.options.modelDescriptions.count];
    for (GXApiModelDescription *description in self.options.modelDescriptions) {
        NSAssert([description isKindOfClass:[GXApiModelDescription class]], @"BFC/_ormResponse: model description in option must be subclass of GXApiModelDescription");
        id object = [self _ormMapping:obj model:description errorPtr:errorPtr];
        if (object && description.keyPath.length) {
            [dict setObject:object forKey:description.keyPath];
        }
        if (*errorPtr && !description.isOptional) {
            return nil;
        }
    }
    return [dict copy];;
}

- (nullable id)_ormMapping:(SKVObject * _Nullable)response model:(GXApiModelDescription * _Nonnull)model errorPtr:(NSError ** _Nonnull)errorPtr
{
    *errorPtr = nil;
    NSMutableArray *responseArray = [NSMutableArray arrayWithCapacity:8];
    if (model.isArray) {
         
        NSArray *x1 = nil; 
        if (model.keyPath.length > 0) {
            x1 = [[self _findObjByPath:model.keyPath obj:response] arrayValue];
        } else {
            x1 = [response arrayValue];
        }
        if (!x1) {
            if (!model.isOptional) {
                *errorPtr = nil;
            }
            return nil;
        }
        for (id obj in x1) {
            id x = nil;
            if ([model.mappingClass isSubclassOfClass:[NSDictionary class]]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *multDict = [NSMutableDictionary dictionaryWithDictionary:obj];
                    [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull val, BOOL * _Nonnull sstop) {
                        if ([[val class] isSubclassOfClass:[NSNull class]]) {
                            [multDict removeObjectForKey:key];
                        }
                    }];
                    x = [multDict copy];
                }
            } else if ([model.mappingClass isSubclassOfClass:[SKVObject class]]) {
                x = [SKVObject of:obj];
            } else if ([model.mappingClass isSubclassOfClass:[NSNumber class]]) {
                if ([obj isKindOfClass:[NSNumber class]]) {
                    x = obj;
                } else if ([obj isKindOfClass:[NSString class]]) {
                    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                    f.numberStyle = NSNumberFormatterDecimalStyle;
                    x = [f numberFromString:obj];
                }
            } else if ([model.mappingClass isSubclassOfClass:[NSString class]]) {
                x = [obj isKindOfClass:[NSString class]] ? obj : [obj description];
            } else if ([model.mappingClass conformsToProtocol:@protocol(GXApiModelProtocol)]) {
                x = [model.mappingClass yy_modelWithDictionary:obj];
            } else {
                x = [model.mappingClass yy_modelWithDictionary:obj];
            }
            if (x) {
                [responseArray addObject:x];
            } else {
                *errorPtr = nil;
                break;
            }
        }
        return *errorPtr ? nil : responseArray;
    } else {
        SKVObject *obj =([model.keyPath length] ? [self _findObjByPath:model.keyPath obj:response] : response);
        if (!obj) {
            if (!model.isOptional) {
                *errorPtr = nil;
            }
            return nil;
        }
        id responseObject = nil;
        if ([model.mappingClass isSubclassOfClass:[NSDictionary class]]) {
            NSMutableDictionary *multDict = [NSMutableDictionary dictionaryWithDictionary:[obj dictionaryValue]];
            /// 根据需求, 如果json解析后的结果中存在key值为NSNull就删除它
            [[obj dictionaryValue] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull val, BOOL * _Nonnull sstop) {
                if ([[val class] isSubclassOfClass:[NSNull class]]) {
                    [multDict removeObjectForKey:key];
                }
            }];
            responseObject = [multDict copy];
        } else if ([model.mappingClass isSubclassOfClass:[SKVObject class]] ) {
            responseObject = obj;
        } else if ([model.mappingClass isSubclassOfClass:[NSNumber class]]) {
            responseObject = [obj numberValue];
        } else if ([model.mappingClass isSubclassOfClass:[NSString class]]) {
            responseObject = [obj isKindOfClass:[NSString class]] ? obj : [obj description];
        } else if ([model.mappingClass conformsToProtocol:@protocol(GXApiModelProtocol)]) {
            responseObject = [model.mappingClass yy_modelWithDictionary:[obj dictionaryValue]];
        } else {
            responseObject = [model.mappingClass yy_modelWithDictionary:[obj dictionaryValue]];
        }
        return responseObject;
    }
}

- (SKVObject *)_findObjByPath:(NSString * _Nonnull)path obj:(SKVObject *)response
{
    if ([path isEqualToString:@"/"]) {
        return response;
    }
    
    NSArray *arr = [path componentsSeparatedByString:@"/"];
    NSMutableArray<NSString *> *pathKeyArr = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
            [pathKeyArr addObject:obj];
        }
    }];
    
    NSString *key = [pathKeyArr firstObject];
    /// 如果就取第一级
    if (pathKeyArr.count == 1) {
        return response[key];
    }
    
    SKVObject *skvObj = response[key];
    
    NSArray *tailPathKeyArr = [pathKeyArr subarrayWithRange:NSMakeRange(1, pathKeyArr.count - 1)];
    return [self _fetchValueInDict:skvObj pathKeyArr:tailPathKeyArr];
}

/// 迭代查找path下key
- (SKVObject *)_fetchValueInDict:(SKVObject *)skvObj pathKeyArr:(NSArray<NSString *> * _Nonnull)pathKeyArr
{
    NSString *key = [pathKeyArr firstObject];
    if (pathKeyArr.count == 1) {
        return skvObj[key];
    }
    NSArray *tailPathKeyArr = [pathKeyArr subarrayWithRange:NSMakeRange(1, pathKeyArr.count - 1)];
    
    return [self _fetchValueInDict:skvObj[key] pathKeyArr:tailPathKeyArr];
}

- (nullable SKVObject *)_serializationFromRawData:(NSData *)data error:(NSError ** _Nonnull)errorPtr
{
    *errorPtr = nil;
    if (!data) {
        return nil;
    }
    id x = [NSJSONSerialization JSONObjectWithData:data options:0 error:errorPtr];
    if (*errorPtr) {
        *errorPtr = nil;
        return nil;
    }
    SKVObject *obj = [SKVObject of:x];

    NSInteger respCode = [obj[@"code"] integerValue];
    if (respCode != 0) {
        NSString *errMsg = [obj[@"message"] stringValue];
        if (!errMsg) {
            errMsg = [obj[@"error"][@"message"] stringValue];
        }

        *errorPtr = nil;
        return nil;
    }
    return obj;
}


@end




