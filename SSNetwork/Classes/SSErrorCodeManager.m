//
//  SSErrorCodeManager.m
//  SSNetworkDemo
//
//  Created by su on 16/6/27.
//  Copyright © 2016年 SS. All rights reserved.
//

#import "SSErrorCodeManager.h"

@interface SSErrorCodeManager ()

@property(nonatomic, strong) NSMutableDictionary *msgDic;
@property(nonatomic, strong) NSMutableDictionary *handlerDic;

@end

@implementation SSErrorCodeManager

+ (SSErrorCodeManager *) shared
{
    static SSErrorCodeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SSErrorCodeManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.msgDic = [[NSMutableDictionary alloc] init];
        self.handlerDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void) setMsg:(NSString *)msg forCode:(NSInteger)code
{
    [self.msgDic setObject:msg forKey:@(code)];
}

- (void) setHandler:(SSErrorCodeHanlder)handler forCode:(NSInteger)code
{
    [self.handlerDic setObject:handler forKey:@(code)];
}

- (NSString *) msgForCode:(NSInteger)code
{
    return [self.msgDic objectForKey:@(code)];
}

- (SSErrorCodeHanlder) handlerForCode:(NSInteger)code
{
    return (SSErrorCodeHanlder)[self.handlerDic objectForKey:@(code)];
}

@end
