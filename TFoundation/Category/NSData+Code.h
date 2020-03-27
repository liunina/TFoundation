//
//  NSData+Code.h
//  TFoundation
//
//  Created by liu nian on 2020/3/10.
//

#import <Foundation/Foundation.h>

void * _Nullable NewBase64Decode(const char * _Nonnull inputBuffer,
								 size_t length,
								 size_t * _Nonnull outputLength);

char * _Nullable NewBase64Encode(const void * _Nonnull inputBuffer,
								 size_t length,
								 bool separateLines,
								 size_t * _Nonnull outputLength);

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Base64)

+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;

// added by Hiroshi Hashiguchi
- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines;

@end

NS_ASSUME_NONNULL_END
