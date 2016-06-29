//
//  SSRequestConfig.h
//  SSNetworkDemo
//
//  Created by su on 16/6/28.
//  Copyright © 2016年 SS. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *SSRequestNetworkStatusChanged;
extern NSString *SSRequestNetworkStatus;

typedef NS_ENUM(NSInteger, SSNetworkStatus) {
    SSNetworkStatusUnknown          = -1,
    SSNetworkStatusNotReachable     = 0,
    SSNetworkStatusReachableWWAN    = 1,
    SSNetworkStatusReachableWiFi    = 2
};

@interface SSRequestConfig : NSObject

+ (SSRequestConfig *) shared;

/**
 *  全局设置网络请求调试信息的开关
 *
 *  @param on true 打开， false 关闭。默认打开
 */
+ (void) setDebugLoggerSwitch:(BOOL)on;
+ (BOOL) debugLoggerSwitch;

/**
 *  全局设置api接口的基本路径
 *
 *  @param basePath 基本路劲
 */
+ (void) setApiBasePath:(NSString *)basePath;

+ (NSString *) apiBasePath;

/**
 *  设置请求内容类型
 *
 *  @param paramsType 设置"application/json"，会采用AFJSONRequestSerializer， 默认使用 AFHTTPRequestSerializer
 */
+ (void) setContentType:(NSString *)contentType;

+ (NSString *) contentType;

/**
 *  全局设置请求HTTP头，对以后所有的请求都有效果
 *
 *  @param header http头
 *  @param value  http头 值
 */
+ (void) setHTTPHeader:(NSString *)header value:(NSString *)value;
+ (NSDictionary *)HTTPHeaders;


+ (void) setTimeoutInterval:(NSTimeInterval)timeoutInterval;
+ (NSTimeInterval)timeoutInterval;

/**
 *  监听网路状态，连接目标地址
 *
 *  @param targetUrl 目标地址
 */
+ (void) monitorNetWorkStatus;

+ (SSNetworkStatus) networkStatus;
+ (BOOL) isReachable;
+ (BOOL) isReachableWWAN;
+ (BOOL) isReachableWiFi;


@end
