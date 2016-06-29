//
//  SSRequest.m
//  SSNetworkDemo
//
//  Created by su on 16/6/15.
//  Copyright © 2016年 SS. All rights reserved.
//

#import "SSRequest.h"
#import "SSNetworking.h"

static Class<SSResponseInterface> _responseClass = nil;

#define max_repeat_request_count 3

#pragma mark - request
@interface SSRequest ()

@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSDictionary *params;
@property(nonatomic, strong) NSURLSessionDataTask *task;

- (id) initWithUrl:(NSString *)url parameters:(NSDictionary *)parameters method:(SSRequestMethod)method;

@end

@implementation SSRequest
{
    NSInteger _lastResponseCode;
    NSInteger _repeatRequestCount;
}

+ (void)initialize
{
    _responseClass = [SSResponse class];
}

+ (SSRequest *) requestWithUrl:(NSString *)url
{
    return [self requestWithUrl:url parameters:nil];
}
+ (SSRequest *) requestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters
{
    return [self requestWithUrl:url parameters:parameters method:GET];
}

+ (SSRequest *) requestWithUrl:(NSString *)url
                    parameters:(NSDictionary *)parameters
                        method:(SSRequestMethod)method
{
    return [[SSRequest alloc] initWithUrl:url parameters:parameters method:method];
}

- (id) initWithUrl:(NSString *)url parameters:(NSDictionary *)parameters method:(SSRequestMethod)method
{
    self = [super init];
    if (self) {
        self.url = url;
        self.params = parameters;
        self.method = method;
    }
    return self;
}

+ (void) registerResponseClass:(Class)responseClass
{
    _responseClass = responseClass;
}

- (void) cancel
{
    [self.task cancel];
}

- (SSResponse *) send
{
    NSDictionary *responseObject = nil;
    NSError *error = nil;
    switch (self.method) {
        case GET:
        {
            responseObject = [[SSNetworking shared] syncGET:self.url parameters:self.params error:&error];
        }
            break;
        case POST:
        {
            responseObject = [[SSNetworking shared] syncPOST:self.url parameters:self.params error:&error];
        }
            break;
        case PUT:
        {
            responseObject = [[SSNetworking shared] syncPUT:self.url parameters:self.params error:&error];
        }
            break;
        case DELETE:
        {
            responseObject = [[SSNetworking shared] syncDELETE:self.url parameters:self.params error:&error];
        }
            break;
        case PATCH:
        {
            responseObject = [[SSNetworking shared] syncPATCH:self.url parameters:self.params error:&error];
        }
            break;
        case HEAD:
        {
            responseObject = [[SSNetworking shared] syncHEAD:self.url parameters:self.params error:&error];
        }
            break;
        default:
            break;
    }
    
    SSResponse *response = nil;
    if (error)
    {
        response = [SSResponse responseWithError:error];
    }
    else
    {
        response = [SSResponse responseWithObject:responseObject];
    }

    return response;
}

- (void) sendWithCallback:(SSRequestCallback)callback
{
    if ([self.delegate respondsToSelector:@selector(startRequest:)]) {
        [self.delegate startRequest:self];
    }
    
    switch (self.method) {
        case GET:
        {
            self.task = [[SSNetworking shared] GET:_url parameters:_params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleSuccessResponse:responseObject callback:callback];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleError:error callback:callback];
            }];
        
        }
            
            break;
        case POST:
        {
            self.task = [[SSNetworking shared] POST:_url parameters:_params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleSuccessResponse:responseObject callback:callback];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleError:error callback:callback];
            }];
        }
            break;
        case PUT:
        {
            self.task = [[SSNetworking shared] PUT:_url parameters:_params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleSuccessResponse:responseObject callback:callback];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleError:error callback:callback];
            }];
        }
            break;
        case DELETE:
        {
            self.task = [[SSNetworking shared] DELETE:_url parameters:_params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleSuccessResponse:responseObject callback:callback];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleError:error callback:callback];
            }];
        }
            break;
        case PATCH:
        {
            self.task = [[SSNetworking shared] PATCH:_url parameters:_params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleSuccessResponse:responseObject callback:callback];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleError:error callback:callback];
            }];
        }
            break;
        case HEAD:
        {
            self.task = [[SSNetworking shared] HEAD:_url parameters:_params success:^(NSURLSessionDataTask * _Nonnull task) {
                [self handleSuccessResponse:nil callback:callback];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleError:error callback:callback];
            }];
        }
            break;
        default:
            break;
    }
}


#pragma private methods
- (void) handleSuccessResponse:(id)responseObject callback:(SSRequestCallback)callback
{
    SSResponse *response = [_responseClass responseWithObject:responseObject];
    [self finishRequest:response callback:callback];
}

- (void) handleError:(NSError *)error callback:(SSRequestCallback)callback
{
    SSResponse *response = [_responseClass responseWithError:error];
    [self finishRequest:response callback:callback];
}

- (void) finishRequest:(SSResponse *)response callback:(SSRequestCallback)callback
{
    NSString *msg = [[SSErrorCodeManager shared] msgForCode:response.code];
    if (msg)
    {
        response.msg = msg;
    }
    
    SSErrorCodeHanlder codeHanlder = [[SSErrorCodeManager shared] handlerForCode:response.code];
    BOOL requestAgain;
    if (codeHanlder)
    {
        requestAgain = codeHanlder(response);
    }
    
    if (requestAgain)
    {
        //跟上一次的错误码是一致的，如果
        if (response.code == _lastResponseCode)
        {
            _repeatRequestCount ++;
        }
        else
        {
            _repeatRequestCount = 0;
        }
        if (_repeatRequestCount < max_repeat_request_count)
        {
            [self sendWithCallback:callback];
            return;
        }
    }
    
    _repeatRequestCount = 0;
    _lastResponseCode = 0;
    
    if (callback)
    {
        callback(response);
    }
    if ([self.delegate respondsToSelector:@selector(request:didFinish:)])
    {
        [self.delegate request:self didFinish:response];
    }
}


@end
