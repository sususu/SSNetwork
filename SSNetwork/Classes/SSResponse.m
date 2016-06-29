//
//  SSResponse.m
//  SSNetworkDemo
//
//  Created by su on 16/6/27.
//  Copyright © 2016年 SS. All rights reserved.
//

#import "SSResponse.h"

@implementation SSResponse

- (BOOL) isOK
{
    return self.code == 0 && ![self.originalData isKindOfClass:[NSError class]];
}

+ (SSResponse *) responseWithObject:(id)object
{
    if (!object) {
        return [self emptyOkResponse];
    }
    SSResponse *response = [[SSResponse alloc] init];
    response.data = [object objectForKey:@"data"];
    response.code = [[object objectForKey:@"code"] integerValue];
    response.msg = [object objectForKey:@"msg"];
    response.originalData = object;
    return response;
}

+ (SSResponse *) responseWithError:(NSError *)error
{
    SSResponse *response = [[SSResponse alloc] init];
    response.code = error.code;
    response.msg = error.domain;
    response.data = error.userInfo;
    response.originalData = error;
    return response;
}


+ (SSResponse *) emptyOkResponse
{
    SSResponse *response = [[SSResponse alloc] init];
    response.code = 0;
    return response;
}

@end
