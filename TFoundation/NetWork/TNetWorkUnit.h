//
//  TNetWorkUnit.h
//  TFoundation
//
//  Created by liu nian on 2020/3/10.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN
//Block
typedef void (^OperationSuccessCompleteBlock)(NSURLSessionTask *sessionTask, id responseObject);
typedef void (^OperationFailureCompleteBlock)(NSURLSessionTask *sessionTask, NSError * error);

typedef enum HttpMethod{
    HttpMethodGet,
    HttpMethodPost,
    HttpMethodPut,
    HttpMethodDelete,
    HttpMethodHEAD,
}HttpMethod;

@interface TNetWorkUnit : AFHTTPSessionManager
/// 取消session中所有的请求
- (void)cancelTasks;

#pragma mark - NSURLRequest
- (NSURLSessionDataTask *)request:(NSURLRequest *)request
             successCompleteBlock:(OperationSuccessCompleteBlock)successCompleteBlock
             failureCompleteBlock:(OperationFailureCompleteBlock)failureCompleteBlock;

- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                   uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                 downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
             successCompleteBlock:(OperationSuccessCompleteBlock)successCompleteBlock
             failureCompleteBlock:(OperationFailureCompleteBlock)failureCompleteBlock;

#pragma mark - JSON Request

/// JSON文本上传方法(POST)
/// @param URLString 上传API路径地址
/// @param parameters 纯表单参数
/// @param successCompleteBlock 成功回调
/// @param failureCompleteBlock 失败回调
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                      jsonParameters:(NSDictionary * __nullable)parameters
                successCompleteBlock:(OperationSuccessCompleteBlock)successCompleteBlock
                failureCompleteBlock:(OperationFailureCompleteBlock)failureCompleteBlock;

#pragma mark -  form Request
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          httpMethod:(HttpMethod)method
                          parameters:(NSDictionary * __nullable)parameters
                successCompleteBlock:(OperationSuccessCompleteBlock)successCompleteBlock
                failureCompleteBlock:(OperationFailureCompleteBlock)failureCompleteBlock;

- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                             inQueue:(dispatch_queue_t __nullable)queue
                          httpMethod:(HttpMethod)method
                          parameters:(NSDictionary * __nullable)parameters
                successCompleteBlock:(OperationSuccessCompleteBlock)successCompleteBlock
                failureCompleteBlock:(OperationFailureCompleteBlock)failureCompleteBlock;

- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                             inQueue:(dispatch_queue_t __nullable)queue
                             inGroup:(dispatch_group_t __nullable)group
                          httpMethod:(HttpMethod)method
                          parameters:(NSDictionary * __nullable)parameters
                successCompleteBlock:(OperationSuccessCompleteBlock)successCompleteBlock
                failureCompleteBlock:(OperationFailureCompleteBlock)failureCompleteBlock;

@end

NS_ASSUME_NONNULL_END
