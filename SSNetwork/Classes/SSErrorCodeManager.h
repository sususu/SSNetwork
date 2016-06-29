//
//  SSErrorCodeManager.h
//  SSNetworkDemo
//
//  Created by su on 16/6/27.
//  Copyright © 2016年 SS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSResponse;

/**
 *  错误码处理代码块，返回YES，则重新请求一次，返回NO，请求不重复进行
 *
 *  @param response 请求结果数据
 *
 *  @return 返回YES，当前请求会重新请求一次（场景：发送一个请求，服务器返回未登录401错误码，可以在block中登录一次，返回YES，继续上一次请求）
 */
typedef BOOL (^SSErrorCodeHanlder)(SSResponse *response);

@interface SSErrorCodeManager : NSObject

+ (SSErrorCodeManager *) shared;

/**
 *  设置错误码的提示信息
 *
 *  @param msg  错误信息
 *  @param code 错误码
 */
- (void) setMsg:(NSString *)msg forCode:(NSInteger)code;

/**
 *  设置错误码的处理块，当请求返回时，会执行对应错误码的处理块
 *
 *  @param handler 处理块
 *  @param code    错误码
 */
- (void) setHandler:(SSErrorCodeHanlder)handler forCode:(NSInteger)code;

- (NSString *) msgForCode:(NSInteger)code;
- (SSErrorCodeHanlder) handlerForCode:(NSInteger)code;


@end
