//
//  GXUrlEncodeTest.m
//  GXRulerTests
//
//  Created by sgx on 2018/1/6.
//  Copyright © 2018年 sunguangxin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Encode.h"

@interface GXUrlEncodeTest : XCTestCase

@end

@implementation GXUrlEncodeTest

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
    NSString *url = @"http://www.baidu.com/s?user=123&psw=321&name=孙";
    
    NSString *encodeUrl = [url stringByUriEncode];
    
    // 测试新的转码api方法与老的转的是否相同
     NSString *oldEncodeUrl = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)url, NULL, CFSTR("!*'\"();:@&=+$,/?%#[]% "), kCFStringEncodingUTF8);
    
    NSLog(@"\n encodeUrl : %@",encodeUrl);
    NSLog(@"\n oldEncodeUrl : %@",oldEncodeUrl);
    XCTAssert([encodeUrl isEqualToString:oldEncodeUrl],@"不一样,出问题啦.");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
