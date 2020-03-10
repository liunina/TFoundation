//
//  TNetWorkUnit.m
//  TFoundation
//
//  Created by liu nian on 2020/3/10.
//

#import "TNetWorkUnit.h"

static NSTimeInterval normalTimeoutInterval = 15;
//static NSTimeInterval uploadTimeoutInterval = 60;

@interface TNetWorkUnit ()
@property (nonatomic, strong) dispatch_queue_t httpRequest_queue_t;
@property (nonatomic, strong) dispatch_group_t httpRequest_group_t;
@end
@implementation TNetWorkUnit

+ (instancetype)manager {
    return [[[self class] alloc] initWithBaseURL:nil];
}

- (instancetype)init {
    return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    return [self initWithBaseURL:url sessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    return [self initWithBaseURL:nil sessionConfiguration:configuration];
}

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        [self.requestSerializer setTimeoutInterval:normalTimeoutInterval];
        [self.reachabilityManager startMonitoring];
    }
    return self;
}

#pragma mark - public methods
// 取消请求
- (void)cancelTasks{
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks){
        if (!dataTasks || !dataTasks.count) {
            return;
        }
        for (NSURLSessionTask *task in dataTasks) {
            [task cancel];
        }
    }];
}

#pragma mark - NSURLRequest
- (NSURLSessionDataTask *)request:(NSURLRequest *)request
             successCompleteBlock:(OperationSuccessCompleteBlock)successCompleteBlock
             failureCompleteBlock:(OperationFailureCompleteBlock)failureCompleteBlock{
    return [self request:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } successCompleteBlock:successCompleteBlock failureCompleteBlock:failureCompleteBlock];
}

- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                   uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                 downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
             successCompleteBlock:(OperationSuccessCompleteBlock)successCompleteBlock
             failureCompleteBlock:(OperationFailureCompleteBlock)failureCompleteBlock{
    
    NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [self operationFailureWithNSURLSessionTask:dataTask
                                                 error:error
                                operationCompleteBlock:failureCompleteBlock];
        } else {
            [self operationSuccessWithNSURLSessionTask:dataTask responseObject:responseObject operationCompleteBlock:successCompleteBlock];
        }
    }];
    [dataTask resume];
    return dataTask;
}
#pragma mark -  form Request
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          httpMethod:(HttpMethod)method
                          parameters:(NSDictionary *)parameters
                successCompleteBlock:(OperationSuccessCompleteBlock)successCompleteBlock
                failureCompleteBlock:(OperationFailureCompleteBlock)failureCompleteBlock{
    return [self requestURL:URLString inQueue:nil httpMethod:method parameters:parameters successCompleteBlock:successCompleteBlock failureCompleteBlock:failureCompleteBlock];
}

- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                             inQueue:(dispatch_queue_t )queue
                          httpMethod:(HttpMethod)method
                          parameters:(NSDictionary *)parameters
                successCompleteBlock:(OperationSuccessCompleteBlock)successCompleteBlock
                failureCompleteBlock:(OperationFailureCompleteBlock)failureCompleteBlock{
    return [self requestURL:URLString inQueue:queue inGroup:nil httpMethod:method parameters:parameters successCompleteBlock:successCompleteBlock failureCompleteBlock:failureCompleteBlock];
}

- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                             inQueue:(dispatch_queue_t)queue
                             inGroup:(dispatch_group_t)group
                          httpMethod:(HttpMethod)method
                          parameters:(NSDictionary *)parameters
                successCompleteBlock:(OperationSuccessCompleteBlock)successCompleteBlock
                failureCompleteBlock:(OperationFailureCompleteBlock)failureCompleteBlock{
    
    NSURLSessionDataTask *dataTask = nil;
    if (method == HttpMethodPost){
        dataTask = [self POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self operationSuccessWithNSURLSessionTask:task
                                        responseObject:responseObject
                                operationCompleteBlock:successCompleteBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self operationFailureWithNSURLSessionTask:task
                                                 error:error
                                operationCompleteBlock:failureCompleteBlock];
        }];
    }else if (method == HttpMethodGet){
        
        dataTask = [self GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self operationSuccessWithNSURLSessionTask:task
                                        responseObject:responseObject
                                operationCompleteBlock:successCompleteBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self operationFailureWithNSURLSessionTask:task
                                                 error:error
                                operationCompleteBlock:failureCompleteBlock];
        }];
    }else if (method == HttpMethodPut){
        
        dataTask = [self PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self operationSuccessWithNSURLSessionTask:task
                                        responseObject:responseObject
                                operationCompleteBlock:successCompleteBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self operationFailureWithNSURLSessionTask:task
                                                 error:error
                                operationCompleteBlock:failureCompleteBlock];
        }];
    }else if (method == HttpMethodDelete){
        
        dataTask = [self DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self operationSuccessWithNSURLSessionTask:task
                                        responseObject:responseObject
                                operationCompleteBlock:successCompleteBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self operationFailureWithNSURLSessionTask:task
                                                 error:error
                                operationCompleteBlock:failureCompleteBlock];
        }];
    }else if (method == HttpMethodHEAD){
        dataTask = [self HEAD:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task) {
            [self operationSuccessWithNSURLSessionTask:task
                                        responseObject:nil
                                operationCompleteBlock:successCompleteBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self operationFailureWithNSURLSessionTask:task
                                                 error:error
                                operationCompleteBlock:failureCompleteBlock];
        }];
    }
    
    AFHTTPRequestSerializer *requestSerializer = self.requestSerializer;
    [requestSerializer setTimeoutInterval:normalTimeoutInterval];
    self.completionQueue = queue;
    self.completionGroup = group;
    return dataTask;
}

#pragma mark - JSON Request
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                      jsonParameters:(NSDictionary *)parameters
                successCompleteBlock:(OperationSuccessCompleteBlock)successCompleteBlock
                failureCompleteBlock:(OperationFailureCompleteBlock)failureCompleteBlock{
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *auth = [self.requestSerializer valueForHTTPHeaderField:@"Authorization"];
    if (auth && auth.length) {
        [requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    }
    
    [requestSerializer setValue:[NSString stringWithFormat:@"%@", [[NSLocale preferredLanguages] componentsJoinedByString:@", "]] forHTTPHeaderField:@"Accept-Language"];
    NSError *rError = nil;
    NSURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&rError];
    if (rError) {
        [self operationFailureWithNSURLSessionTask:nil
                                             error:rError
                            operationCompleteBlock:failureCompleteBlock];
        return nil;
    }
    NSURLSessionDataTask *dataTask = nil;
    dataTask = [self request:request successCompleteBlock:^(NSURLSessionTask * _Nonnull sessionTask, id  _Nonnull responseObject) {
         [self operationSuccessWithNSURLSessionTask:sessionTask responseObject:responseObject operationCompleteBlock:successCompleteBlock];
    } failureCompleteBlock:^(NSURLSessionTask * _Nonnull sessionTask, NSError * _Nonnull error) {
        [self operationFailureWithNSURLSessionTask:sessionTask
                                             error:error
                            operationCompleteBlock:failureCompleteBlock];
    }];
    return dataTask;
}

#pragma mark - private methods
- (void)operationSuccessWithNSURLSessionTask:(NSURLSessionTask *)dataTask
                              responseObject:(id)responseObject
                      operationCompleteBlock:(OperationSuccessCompleteBlock)completeBlock{
    if (completeBlock) {
        completeBlock(dataTask, responseObject);
    }
}

- (void)operationFailureWithNSURLSessionTask:(NSURLSessionTask *)dataTask
                                       error:(NSError *)error
                      operationCompleteBlock:(OperationFailureCompleteBlock)completeBlock{
    if (completeBlock) {
        completeBlock(dataTask, error);
    }
}

#pragma mark getter
- (dispatch_queue_t)httpRequest_queue_t{
    if (_httpRequest_queue_t == nil) {
        _httpRequest_queue_t = dispatch_queue_create("com.t11.serialQueue.defaultHttpRequest", DISPATCH_QUEUE_SERIAL);
    }
    return _httpRequest_queue_t;
}

- (dispatch_group_t)httpRequest_group_t{
    if (!_httpRequest_group_t) {
        _httpRequest_group_t = dispatch_group_create();
    }
    return _httpRequest_group_t;
}

@end
