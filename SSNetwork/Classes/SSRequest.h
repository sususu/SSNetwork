//
//  SSRequest.h
//  SSNetworkDemo
//
//  Created by su on 16/6/15.
//  Copyright © 2016年 SS. All rights reserved.
//

#import "SSResponse.h"
#import "SSErrorCodeManager.h"
#import "SSRequestConfig.h"

@class SSRequest;
@class SSResponse;

#pragma mark - enums
typedef NS_ENUM(NSInteger, SSRequestMethod) {
    GET = 0,
    POST = 1,
    PUT = 2,
    DELETE = 3,
    PATCH = 4,
    HEAD = 5
};

#pragma mark - block
typedef void (^SSRequestCallback)(SSResponse *response);

#pragma mark - delegate
@protocol SSRequestDelegate <NSObject>

- (void) startRequest:(SSRequest *)request;
- (void) request:(SSRequest *)request didFinish:(SSResponse *)response;

@end


@interface SSRequest : NSObject

#pragma mark - public static

+ (SSRequest *) requestWithUrl:(NSString *)url;
+ (SSRequest *) requestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters;

+ (SSRequest *) requestWithUrl:(NSString *)url
                    parameters:(NSDictionary *)parameters
                        method:(SSRequestMethod)method;

#pragma mark - public properties
@property(readonly, nonatomic, assign) SSNetworkStatus networkStatus;
@property(readonly, nonatomic, assign, getter=isReachable) BOOL reachable;
@property(readonly, nonatomic, assign, getter=isReachableWWAN) BOOL reachableWWAN;
@property(readonly, nonatomic, assign, getter = isReachableWiFi) BOOL reachableWiFi;
@property(nonatomic, assign) SSRequestMethod method;


@property(nonatomic, weak) id<SSRequestDelegate> delegate;

#pragma mark - public methods

+ (void) registerResponseClass:(Class<SSResponseInterface>)responseClass;
/**
 *  取消请求
 */
- (void) cancel;

/**
 *  发送同步请求，直接返回数据
 */
- (SSResponse *) send;

/**
 *  发送请求，请求完成之后回调
 *
 *  @param callback 回调代码块
 */
- (void) sendWithCallback:(SSRequestCallback)callback;

@end
