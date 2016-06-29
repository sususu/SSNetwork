//
//  SSNetworking.h
//  SSNetworkDemo
//
//  Created by su on 16/6/27.
//  Copyright © 2016年 SS. All rights reserved.
//

#import "AFNetworking.h"

@interface SSNetworking : AFHTTPSessionManager

+ (SSNetworking *) shared;

- (void) setHTTPHeader:(NSString *)value forKey:(NSString *)key;
- (void) removeHTTPHeaderForKey:(NSString *)key;

- (NSDictionary *) syncGET:(NSString *)url parameters:(NSDictionary *)parameters error:(NSError **)error;
- (NSDictionary *) syncPOST:(NSString *)url parameters:(NSDictionary *)parameters error:(NSError **)error;
- (NSDictionary *) syncPUT:(NSString *)url parameters:(NSDictionary *)parameters error:(NSError **)error;
- (NSDictionary *) syncDELETE:(NSString *)url parameters:(NSDictionary *)parameters error:(NSError **)error;
- (NSDictionary *) syncHEAD:(NSString *)url parameters:(NSDictionary *)parameters error:(NSError **)error;
- (NSDictionary *) syncPATCH:(NSString *)url parameters:(NSDictionary *)parameters error:(NSError **)error;

@end
