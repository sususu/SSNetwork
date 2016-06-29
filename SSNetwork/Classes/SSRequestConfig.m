//
//  SSRequestConfig.m
//  SSNetworkDemo
//
//  Created by su on 16/6/28.
//  Copyright © 2016年 SS. All rights reserved.
//

#import "SSRequestConfig.h"
#import <AFNetworking/AFNetworking.h>

#define ss_timeout 60
NSString *SSRequestNetworkStatusChanged = @"request.network.status.changed";
NSString *SSRequestNetworkStatus = @"request.network.status";
NSString *SSContentType = @"ContentType";

@interface SSRequestConfig ()

@property(nonatomic, assign) SSNetworkStatus networkStatus;
@property(nonatomic, assign) BOOL logSwitch;
@property(nonatomic, assign) NSTimeInterval timeoutInterval;
@property(nonatomic, strong) NSString *basePath;
@property(nonatomic, strong) NSMutableDictionary *headers;
@property(nonatomic, strong) NSMutableDictionary *config;

@end

@implementation SSRequestConfig

+ (SSRequestConfig *) shared
{
    static SSRequestConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[SSRequestConfig alloc] init];
        
    });
    return config;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.logSwitch = YES;
        self.headers = [[NSMutableDictionary alloc] init];
        self.config = [[NSMutableDictionary alloc] init];
        self.networkStatus = SSNetworkStatusReachableWiFi;
        self.timeoutInterval = ss_timeout;

    }
    return self;
}


- (void) monitorNetWorkStatus
{
    self.networkStatus = (NSInteger)[[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    __weak __typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.networkStatus = (NSInteger)status;
        [[NSNotificationCenter defaultCenter] postNotificationName:SSRequestNetworkStatusChanged object:nil userInfo:@{SSRequestNetworkStatus: @(strongSelf.networkStatus)}];
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


#pragma mark - 配置方法
+ (void) setDebugLoggerSwitch:(BOOL)on
{
    [[SSRequestConfig shared] setLogSwitch:on];
}

+ (BOOL) debugLoggerSwitch
{
    return [[SSRequestConfig shared] logSwitch];
}

+ (void) setApiBasePath:(NSString *)basePath
{
    [[SSRequestConfig shared] setBasePath:basePath];
}

+ (NSString *) apiBasePath
{
    return [SSRequestConfig shared].basePath;
}

+ (void) setContentType:(NSString *)contentType
{
    [[SSRequestConfig shared].config setObject:contentType forKey:SSContentType];
}

+ (NSString *) contentType
{
    return [[SSRequestConfig shared].config objectForKey:SSContentType];
}

+ (void) setHTTPHeader:(NSString *)header value:(NSString *)value
{
    [[[SSRequestConfig shared] headers] setObject:value forKey:header];
}

+ (NSDictionary *)HTTPHeaders
{
    return [[SSRequestConfig shared] headers];
}

+ (void) setTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    [SSRequestConfig shared].timeoutInterval = timeoutInterval;
}
+ (NSTimeInterval)timeoutInterval
{
    return [SSRequestConfig shared].timeoutInterval;
}


#pragma mark - 网络状态
+ (void) monitorNetWorkStatus
{
    [[SSRequestConfig shared] monitorNetWorkStatus];
}

+ (SSNetworkStatus) networkStatus
{
    return [SSRequestConfig shared].networkStatus;
}
+ (BOOL) isReachable
{
    return [SSRequestConfig shared].networkStatus == SSNetworkStatusReachableWiFi || [SSRequestConfig shared].networkStatus == SSNetworkStatusReachableWWAN;
}
+ (BOOL) isReachableWWAN
{
    return [SSRequestConfig shared].networkStatus == SSNetworkStatusReachableWWAN;
}
+ (BOOL) isReachableWiFi
{
    return [SSRequestConfig shared].networkStatus == SSNetworkStatusReachableWiFi;
}


@end
