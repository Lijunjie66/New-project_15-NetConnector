//
//  main.m
//  New-project_15-NetConnector
//
//  Created by Geraint on 2018/4/17.
//  Copyright © 2018年 kilolumen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NetConnector.h"

#define INDEX_URL @"http://www.wikipedia.com/index.html"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        // 获取当前的 运行循环
        NSRunLoop *loop = [NSRunLoop currentRunLoop];
        
        // 使用指定的缓存策略创建请求，然后开始下载
        NSURLRequest *request  = [NSURLRequest requestWithURL:[NSURL URLWithString:INDEX_URL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
        NetConnector *netConnect = [[NetConnector alloc] initWithRequest:request];
        
        // 一直循环，直到加载资源操作结束为止（注意空语句）
        while (!netConnect.finishedLoading && [loop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
        
        // 记录缓存占用的内存大小
        NSLog(@"Cache memory usage = %lu bytes",[[NSURLCache sharedURLCache] currentMemoryUsage]);
        
        // 通过请求重新加载数据，这次会从缓存获取数据!
        [netConnect reloadRequest];
        while (!netConnect.finishedLoading && [loop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
        
        // 释放缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
