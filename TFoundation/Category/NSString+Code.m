//
//  NSString+Code.m
//  TFoundation
//
//  Created by liu nian on 2020/3/10.
//

#import "NSString+Code.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
#import <GTMBase64/GTMBase64.h>

@implementation NSString(MD5)

- (NSString *)stringFromMD5 {
    if (self==nil || [self length]==0) {
        return nil;
    }
    
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count=0; count<CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    return outputString;
}

@end

@implementation NSString (Aes128)

#pragma mark aes加密，
+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key {
    //把string转NSData
    NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    //length
    size_t plainTextBufferSize = [data length];
    const void*vplainText = (const void*)[data bytes];
    uint8_t*bufferPtr =NULL;
    size_t bufferPtrSize =0;
    size_t movedBytes =0;
    bufferPtrSize = (plainTextBufferSize +kCCBlockSizeAES128) & ~(kCCBlockSizeAES128-1);
    bufferPtr =malloc( bufferPtrSize *sizeof(uint8_t));
    memset((void*)bufferPtr,0x0, bufferPtrSize);
    const void*vkey = (const void*) [key UTF8String];
    
    //配置CCCrypt
    CCCryptorStatus ccStatus =CCCrypt(kCCEncrypt,
                                     kCCAlgorithmAES128,//3DES
                                     kCCOptionECBMode|kCCOptionPKCS7Padding,//设置模式
                                     vkey,//key
                                     kCCKeySizeAES192,
                                     nil,//偏移量，这里不用，设置为nil;不用的话，必须为nil,不可以为@“”
                                     vplainText,
                                     plainTextBufferSize,
                                     (void*)bufferPtr,
                                     bufferPtrSize,
                                     &movedBytes);
    
    if(ccStatus ==kCCSuccess) {
        NSData*myData = [NSData dataWithBytes:(const char*)bufferPtr length:(NSUInteger)movedBytes];
        free(bufferPtr);
        return [GTMBase64 stringByEncodingData:myData];
    }
	free(bufferPtr);
    return nil;
}


@end
