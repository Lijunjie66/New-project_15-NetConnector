//
//  NetConnector.m
//  New-project_15-NetConnector
//
//  Created by Geraint on 2018/4/23.
//  Copyright © 2018年 kilolumen. All rights reserved.
//

#import "NetConnector.h"

@interface NetConnector()

// 通过扩展声明，提供属性 ,并且是 NetConnector类的实现代码中使用的 【私有属性】
@property NSURLRequest *request;
@property BOOL finishedLoading;
@property NSURLConnection *connector;
@property NSMutableData *receivedData;

@end

@implementation NetConnector

- (id) initWithRequest:(NSURLRequest *)requset {
    if (self = [super init]) {
        _request = requset;  // 将NSRULRequest实例赋予 私有的属性 request
        
        // 通过合适的内存储存结构，创建URL缓存
        NSURLCache *URLCache = [[NSURLCache alloc] init];
        [URLCache setMemoryCapacity:CACHE_MEMORY_SIZE];
        [NSURLCache setSharedURLCache:URLCache];
        // 创建连接并开始下载资源数据   [ 协议 ]
        _connector = [NSURLConnection connectionWithRequest:requset delegate:self];
    }
    return self;
}

- (id) reloadRequest {
    self.finishedLoading = NO;
    
    // ios 9.0 后弃用
    self.connector = [NSURLConnection connectionWithRequest:self.request
                                                   delegate:self];
    return self.connector;
}

#pragma mark -
#pragma mark Delegate methods
- (void) connection:(NSURLConnection *)connection
 didReceiveResponse:(nonnull NSURLResponse *)response {
    if (self.receivedData != nil) {
        [self.receivedData setLength:0];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    NSURLResponse *response = [cachedResponse response];
    NSURL *url = [response URL];
    if ([[url scheme] isEqualToString:HTTP_SCHEME]) {
        NSLog( @"Downloaded date, caching response");
        return cachedResponse;
    } else {
        NSLog(@"Downloaded date, not caching response");
        return nil;
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(nonnull NSData *)data {
    if (self.receivedData != nil) {
        [self.receivedData appendData:data];
    } else {
        self.receivedData = [[NSMutableData alloc] initWithData:data];
    }
}

- (void)connectionDidFininshLoading:(NSURLConnection *)connection {
    NSUInteger length = [self.receivedData length];
    NSLog(@"Downloaded %lu bytes from request %@",length, self.request);
    
    // 加载数据后，设置退出运行循环的标记
    self.finishedLoading = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error loading request %@", [error localizedDescription]);
    self.finishedLoading = YES;
}

/*
- (void)requestDataWithUrl:(NSString *)url completion:(void (^)(id))completion {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask * dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (completion) {
            completion(result);
        }
    }];
    [dataTask resume];
}
*/


@end
