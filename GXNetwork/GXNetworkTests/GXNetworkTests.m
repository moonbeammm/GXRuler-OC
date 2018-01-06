//
//  GXNetworkTests.m
//  GXNetworkTests
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <GXNetwork/GXNetworkManager.h>

@interface GXNetworkTests : XCTestCase

@end

@implementation GXNetworkTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSunxxxxApi {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    GXApiOptions *options = [[GXApiOptions alloc] init];
    options.baseUrl = @"http://www.sunxxxxx.com/app-rec-tab";
    
    [[[GXNetworkManager alloc] initWithOptions:options progress:^(NSProgress * _Nullable downloadProgress) {
        NSLog(@"ViewController: progress: %@",downloadProgress);
    } success:^(NSDictionary * _Nullable result, NSURLResponse * _Nullable response) {
        NSLog(@"ViewController: \ntask: \n%@\nresponseObject:\n%@",result,response);
    } failure:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        NSLog(@"ViewController: task: %@>>>>error:%@",result,error);
    }] requestAsync];
}

// 映客直播列表API
- (void)testYingKeApi {
    GXApiOptions *options = [[GXApiOptions alloc] init];
    options.baseUrl = @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";
    
    [[[GXNetworkManager alloc] initWithOptions:options progress:^(NSProgress * _Nullable downloadProgress) {
        NSLog(@"ViewController: progress: %@",downloadProgress);
    } success:^(NSDictionary * _Nullable result, NSURLResponse * _Nullable response) {
        NSLog(@"ViewController: \ntask: \n%@\nresponseObject:\n%@",result,response);
    } failure:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        NSLog(@"ViewController: task: %@>>>>error:%@",result,error);
    }] requestAsync];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
