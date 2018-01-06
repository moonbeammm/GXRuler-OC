//
//  GXNetwork.h
//  GXNetwork
//
//  Created by sunguangxin on 2017/4/20.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for GXNetwork.
FOUNDATION_EXPORT double GXNetworkVersionNumber;

//! Project version string for GXNetwork.
FOUNDATION_EXPORT const unsigned char GXNetworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GXNetwork/PublicHeader.h>
#import <GXNetwork/GXNetworkManager.h>
#import <GXNetwork/GXApiOptions.h>
#import <GXNetwork/GXApiModelProtocol.h>

/*
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
该库其实就是对以下4个步骤做了一层封装.
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 
1.创建一个网络路径
NSURL *url = [NSURL URLWithString:@"http://www.mocky.io/v2/59b3f210100000d50b236b80"];
 
2.创建一个网络请求
NSURLRequest *request =[NSURLRequest requestWithURL:url];
 
3.获得会话对象
NSURLSession *session = [NSURLSession sharedSession];
 
4.根据会话对象，创建一个Task任务：
NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"从服务器获取到数据");
    对从服务器获取到的数据data进行相应的处理：
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
}];
 
5.最后一步，执行任务（resume也是继续执行）:
[sessionDataTask resume];
*/










