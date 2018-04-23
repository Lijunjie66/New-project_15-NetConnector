//
//  NetConnector.h
//  New-project_15-NetConnector
//
//  Created by Geraint on 2018/4/23.
//  Copyright © 2018年 kilolumen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HTTP_SCHEME @"http"
#define CACHE_MEMORY_SIZE (4 * 1024 * 1024)

// 接口采用 NSURLConnectionDelegate 协议 ，能够通过异步加载来自 NSURLConnection实例 的数据
@interface NetConnector : NSObject <NSURLConnectionDelegate>

// 该属性，表明实例已经结束了加载数据操作
@property (readonly) BOOL finishedLoading;

// 初始化一个 NetConnector对象，并使用输入的 NSURLRequest对象 加载URL
- (id) initWithRequest:(NSURLRequest *)requset;
// 用于 重新加载输入的 NSURLRequest对象
- (id) reloadRequest;

@end
