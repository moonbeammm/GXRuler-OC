//
//  GXAppendParamTest.m
//  GXRulerTests
//
//  Created by sgx on 2018/1/6.
//  Copyright © 2018年 sunguangxin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+AppendParam.h"

@interface GXAppendParamTest : XCTestCase

@end

@implementation GXAppendParamTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString *url1 = @"www.url.com/path";
    NSString *appendUrl1 = [url1 appendParamKey:@"from" paramValue:@"12"];
    XCTAssert([appendUrl1 isEqualToString:@"www.url.com/path?from=12"],@"不对");
    
    NSString *url2 = @"www.url.com/path?mid=11";
    NSString *appendUrl2 = [url2 appendParamKey:@"from" paramValue:@"12"];
    XCTAssert([appendUrl2 isEqualToString:@"www.url.com/path?mid=11&from=12"],@"不对");
    
    NSString *url3 = @"www.url.com/path?mid=11&case=22#test=2";
    NSString *appendUrl3 = [url3 appendParamKey:@"from" paramValue:@"12"];
    XCTAssert([appendUrl3 isEqualToString:@"www.url.com/path?mid=11&case=22&from=12#test=2"],@"不对");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
