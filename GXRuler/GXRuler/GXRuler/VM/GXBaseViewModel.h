//
//  GXBaseViewModel.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXBaseViewModel : NSObject

@property (nonatomic) NSArray *objects;

@property (nonatomic) BOOL isLoading;
@property (nonatomic) BOOL isEnd;

- (void)loadData;
- (void)tryLoadData;
- (void)tryLoadMoreData;

- (Class)getCellClassWithModelName:(NSString *)modelName;
- (NSDictionary *)dataCellClassMapping;

@end
