//
//  TFileManager.m
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import "TFileManager.h"

@implementation TFileManager

+ (NSString *)appDocPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)appLibPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)appCachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (BOOL)isFileExsit:(NSString *)aPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:aPath];
}

+ (BOOL)isFileExsitInDoc:(NSString *)aPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [self appDocPath];
    [path stringByAppendingPathComponent:aPath];
    return [manager fileExistsAtPath:path];
}

+ (BOOL)isBundleExsit:(NSString *)aBundleName {
    return [[NSBundle mainBundle] URLForResource:aBundleName withExtension:@"bundle"] ? YES : NO;
}
@end
