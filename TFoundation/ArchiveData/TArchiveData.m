//
//  TArchiveData.m
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import "TArchiveData.h"
#import "TFileManager.h"

@implementation TArchiveData

+ (void)archiveDataInDoc:(id<NSCoding>)aData withFileName:(NSString *)aFileName {
    NSString *documentPath = [TFileManager appDocPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:aFileName];
    
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:aData];
    [archiveData writeToFile:filePath atomically:NO];
}

+ (id<NSCoding>)unarchiveDataInDocWithFileName:(NSString *)aFileName {
    NSString *documentPath = [TFileManager appDocPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:aFileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (void)archiveDataInCache:(id<NSCoding>)aData withFileName:(NSString *)aFileName {
    NSString *documentPath = [TFileManager appCachePath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:aFileName];
    
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:aData];
    [archiveData writeToFile:filePath atomically:NO];
}

+ (id<NSCoding>)unarchiveDataInCacheWithFileName:(NSString *)aFileName {
    NSString *documentPath = [TFileManager appCachePath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:aFileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (id<NSCoding>)unarchiveDataInMainBundleWithFileName:(NSString *)aFileName {
    return [self unarchiveDataWithFileName:aFileName andBundleName:nil];
}

+ (id<NSCoding>)unarchiveDataWithFileName:(NSString *)aFileName andBundleName:(NSString *)aBundleName {
    NSBundle *bundle = [NSBundle mainBundle];
    if (aBundleName.length) {
        bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:aBundleName withExtension:@"bundle"]];
    }
    
    NSString *resourcePath = [bundle resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:aFileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

@end
