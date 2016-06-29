//
//  SSNetworking.m
//  SSNetworkDemo
//
//  Created by su on 16/6/27.
//  Copyright © 2016年 SS. All rights reserved.
//

#import "SSNetworking.h"
#import "SSRequestConfig.h"

@implementation SSNetworking

+ (SSNetworking *) shared
{
    static SSNetworking *networking;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networking = [[SSNetworking alloc] init];
    });
    return networking;
    
}

- (id) init
{
    NSURL *baseUrl = nil;
    
    NSString *basePath = [SSRequestConfig apiBasePath];
    if (basePath) {
        baseUrl = [NSURL URLWithString:basePath];
    }
    self = [super initWithBaseURL:baseUrl];
    if (self) {

        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        NSString *contentType = [SSRequestConfig contentType];
        if (contentType && [contentType isEqualToString:@"application/json"])
        {
            self.requestSerializer = [AFJSONRequestSerializer serializer];
        }
        
        [self initRequestSerializer:self.requestSerializer];
    }
    return self;
}

- (void) initRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer
{
    [self setHTTPHeader:@"application/json" forKey:@"Accept"];
    [self.requestSerializer setTimeoutInterval:[SSRequestConfig timeoutInterval]];
    
    NSDictionary *headers = [SSRequestConfig HTTPHeaders];
    for (NSString *hk in headers.allKeys)
    {
        id hv = [headers objectForKey:hk];
        [self setHTTPHeader:hv forKey:hk];
        
    }
}


- (void) setHTTPHeader:(NSString *)value forKey:(NSString *)key
{
    [self.requestSerializer setValue:value forHTTPHeaderField:key];
}

- (void) removeHTTPHeaderForKey:(NSString *)key
{
    [self setHTTPHeader:@"" forKey:key];
}


#pragma mark - public methods
- (NSDictionary *) syncGET:(NSString *)url parameters:(NSDictionary *)parameters error:(NSError **)error
{
    return [self syncRequest:url method:@"GET" parameters:parameters error:error];
}

- (NSDictionary *) syncPOST:(NSString *)url parameters:(NSDictionary *)parameters error:(NSError **)error
{
    return [self syncRequest:url method:@"POST" parameters:parameters error:error];
}

- (NSDictionary *) syncPUT:(NSString *)url parameters:(NSDictionary *)parameters error:(NSError **)error
{
    return [self syncRequest:url method:@"PUT" parameters:parameters error:error];
}

- (NSDictionary *) syncDELETE:(NSString *)url parameters:(NSDictionary *)parameters error:(NSError **)error
{
    return [self syncRequest:url method:@"DELETE" parameters:parameters error:error];
}

- (NSDictionary *) syncHEAD:(NSString *)url parameters:(NSDictionary *)parameters error:(NSError **)error
{
    return [self syncRequest:url method:@"HEAD" parameters:parameters error:error];
}

- (NSDictionary *) syncPATCH:(NSString *)url parameters:(NSDictionary *)parameters error:(NSError **)error
{
    return [self syncRequest:url method:@"PATCH" parameters:parameters error:error];
}

- (NSDictionary *) syncRequest:(NSString *)url method:(NSString *)method parameters:(NSDictionary *)params error:(NSError **)error
{
    AFHTTPRequestSerializer *requestSerializer = nil;
    NSString *contentType = [SSRequestConfig contentType];
    if (contentType && [contentType isEqualToString:@"application/json"])
    {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    else
    {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    if (error) {
        return nil;
    }
    [self initRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:url parameters:params error:error];
    
    NSHTTPURLResponse *response = nil;
    if ([SSRequestConfig debugLoggerSwitch])
    {
        NSLog(@"请求方法：%@", method);
        NSLog(@"请求URL：%@", url);
        NSLog(@"请求参数：%@", request.allHTTPHeaderFields);
        NSLog(@"请求BODY：%@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    }
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    if (error) {
        NSLog(@"请求出错：%@", *error);
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
}


@end
