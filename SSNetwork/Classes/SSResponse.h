//
//  SSResponse.h
//  SSNetworkDemo
//
//  Created by su on 16/6/27.
//  Copyright © 2016年 SS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSResponse;

@protocol SSResponseInterface <NSObject>

@required
+ (SSResponse *) responseWithObject:(id)object;
+ (SSResponse *) responseWithError:(NSError *)error;

@end

@interface SSResponse : NSObject<SSResponseInterface>

@property(nonatomic, assign, readonly, getter=isOK) BOOL ok;

@property(nonatomic, assign) NSInteger code;
@property(nonatomic, strong) id data;
@property(nonatomic, strong) NSString *msg;
@property(nonatomic, strong) id originalData;

//+ (SSResponse *) responseWithObject:(id)object;
//+ (SSResponse *) responseWithError:(NSError *)error;

@end
