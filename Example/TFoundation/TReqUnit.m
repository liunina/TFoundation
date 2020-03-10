//
//  TReqManager.m
//  TFoundation_Example
//
//  Created by liu nian on 2020/3/10.
//  Copyright © 2020 i19850511@gmail.com. All rights reserved.
//

#import "TReqUnit.h"


NSString *H5_HOST = @"https://api.myt11.com";
NSString *API_HOST = @"https://api.myt11.com";
//测试时候使用
static NSString *BETA_HOST = @"https://api-dev.myt11.com";
static NSString *TEST_HOST = @"https://api-test.myt11.com";

@interface TReqUnit ()

@end
@implementation TReqUnit

+ (instancetype)sharedClient {
    static TReqUnit *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *host = API_HOST;
        _sharedClient = [[TReqUnit alloc] initWithBaseURL:[NSURL URLWithString:host]];
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:[NSString stringWithFormat:@"%@", [[NSLocale preferredLanguages] componentsJoinedByString:@", "]]
                 forHTTPHeaderField:@"Accept-Language"];
        [requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json", nil];
        _sharedClient.requestSerializer = requestSerializer;
        _sharedClient.responseSerializer = responseSerializer;
    });
    
    return _sharedClient;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}
@end
