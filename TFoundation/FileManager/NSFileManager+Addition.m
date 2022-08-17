//
//  NSFileManager+Addition.m
//  TFoundation
//
//  Created by liu nian on 2020/3/29.
//

#import "NSFileManager+Addition.h"
#include <sys/stat.h>
#import "TFoundation+Options.h"

@implementation NSFileManager (Addition)

#pragma mark - ----

BOOL ineternal_createDirectoryForFilePath(NSString *path, BOOL isOverwrite)
{
    NSString *lastComponent = [path lastPathComponent];
    NSString *toFolder = path;
    if (lastComponent.length > 0) {
        toFolder = [path substringWithRange:NSMakeRange(0, [path length] - [lastComponent length])];
    }
    
    return ineternal_createDirectory(toFolder, isOverwrite);
}

BOOL ineternal_createDirectory(NSString *dirPath, BOOL isOverwrite)
{
    if (dirPath.length == 0) {
        return NO;
    }
    
    NSFileManager *fileMng = [NSFileManager defaultManager];
    
    BOOL ret = YES;
    NSError *error = nil;
    BOOL isDir = YES;
    if ([fileMng fileExistsAtPath:dirPath isDirectory:&isDir]) {
        if (!isDir) {
            remove([dirPath UTF8String]);
        }
        if (isOverwrite) {
            ret = [fileMng removeItemAtPath:dirPath error:&error];
            ret &= (error == nil);
            
        }
    }
    
    if (ret) {
        ret = [fileMng createDirectoryAtPath:dirPath
                 withIntermediateDirectories:YES
                                  attributes:nil
                                       error:&error];
        ret &= (error == NULL);
        
    }
    
    return ret;
}

+ (BOOL)createDirectory:(NSString *)path
{
    return ineternal_createDirectory(path, NO);
}

#pragma mark - ----

BOOL internal_copyFile(NSString *from, NSString *to, BOOL isRemove)
{
    if (access([from UTF8String], 0) != 0 || to.length == 0) {
        return NO;
    }
    
    BOOL ret = ineternal_createDirectoryForFilePath(to,NO);
    if (ret) {
        NSError *error = NULL;
        remove([to UTF8String]);
        
        if (isRemove) {
            remove([to UTF8String]);
            ret = [[NSFileManager defaultManager] moveItemAtPath:from toPath:to error:&error];
        } else {
            ret = [[NSFileManager defaultManager] copyItemAtPath:from toPath:to error:&error];
        }
        ret &= (error==NULL);
        
    }
    
    return ret;
}

+ (BOOL)copyFileFrom:(NSString *)from to:(NSString *)to
{
    return internal_copyFile(from, to, NO);
}

+ (BOOL)moveFileFrom:(NSString *)from to:(NSString *)to
{
    return internal_copyFile(from, to, YES);
}

#pragma mark - ----

BOOL internal_copyDirectory(NSString *from, NSString *to, BOOL isRemove)
{
    if (access([from UTF8String], 0) != 0 || to.length == 0) {
        return NO;
    }
    
    NSFileManager *fileMng = [NSFileManager defaultManager];
    NSString *fromDirName = [from lastPathComponent];
    to = [to stringByAppendingPathComponent:fromDirName];
    
    BOOL ret = [NSFileManager createDirectory:to];
    if (ret) {
        NSError *error = nil;
        NSArray *allFiles = [fileMng contentsOfDirectoryAtPath:from error:&error];
        if (error) {
            ret = NO;
        } else {
            for (NSString *fileName in allFiles) {
                NSString *fromPath = [from stringByAppendingPathComponent:fileName];
                NSString *toPath = [to stringByAppendingPathComponent:fileName];
                BOOL tmpRet = NO;
                
                if (isRemove) {
                    remove([toPath UTF8String]);
                    tmpRet = [fileMng moveItemAtPath:fromPath toPath:toPath error:&error];
                } else {
                    tmpRet = [fileMng copyItemAtPath:fromPath toPath:toPath error:&error];
                }
                
                if (error && !tmpRet) {
                    ret = NO;
                    break;
                }
            }
        }
    }
    
    return ret;
}

+ (BOOL)copyDirectoryFrom:(NSString *)from to:(NSString *)to
{
    return internal_copyDirectory(from, to, NO);
}

+ (BOOL)moveDirectoryFrom:(NSString *)from to:(NSString *)to
{
    return internal_copyDirectory(from, to, YES);
}

#pragma mark - ----

+ (long long)fileSize:(NSString *)path
{
    NSFileManager *fileMng = [NSFileManager defaultManager];
    NSError *error = NULL;
    NSDictionary *attribute = [fileMng attributesOfItemAtPath:path error:&error];
    long long fileLen = 0;
    if (error) {
    }
    else {
        fileLen = [[attribute objectForKey:NSFileSize] longLongValue];
    }
    
    return fileLen;
}

+ (NSDate *)fileModifyTimestamp:(NSString *)path
{
    struct stat st;
    if(lstat([path cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0) {
        return [NSDate dateWithTimeIntervalSince1970:st.st_mtimespec.tv_sec];
    }
    return 0;
}

long long internal_fileSize(NSString* filePath)
{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

+ (long long)directorySize:(NSString*)dirPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:dirPath]) {
        return 0;
    }
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:dirPath] objectEnumerator];
    NSString* fileName = NULL;
    
    long long dirFileSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString* fileAbsolutePath = [dirPath stringByAppendingPathComponent:fileName];
        dirFileSize += internal_fileSize(fileAbsolutePath);
    }
    
    return dirFileSize;
}

+ (NSDate *)directoryModifyTimestamp:(NSString *)path
{
    return [NSFileManager fileModifyTimestamp:path];
}

#pragma mark - ----

+ (BOOL)removeDirectory:(NSString*)dir
{
    if (dir.length == 0) {
        return NO;
    }
    
    NSFileManager *fileMng = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExist = [fileMng fileExistsAtPath:dir isDirectory:&isDirectory];
    if (isExist && isDirectory) {
        NSError *error = NULL;
        BOOL ret = [fileMng removeItemAtPath:dir error:&error];
        ret &= (error == NULL);
        return ret;
    }
    
    return YES;
}

+(BOOL)documentFileExitsWithAppendComponent:(NSString*)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentPath = [documents objectAtIndex:0];
    if (documents.count <= 0) return NO;
    NSString *path = [documentPath stringByAppendingPathComponent:fileName];
    return [fileManager fileExistsAtPath:path];
    
}

+ (NSString*)getSaveVedioWithVideoUrlStr:(NSString*)videoStr{
    NSString *videoPath = @"";
    if (videoStr.length==0) {
        return videoPath;
    }
    
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *fileList = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:string error:nil] pathsMatchingExtensions:@[@"mp4"]];
    NSString *judgeStr = @"";
    if ([videoStr rangeOfString:@".mp4"].location!=NSNotFound) {
        NSArray *arr = [videoStr componentsSeparatedByString:@".mp4"];
        NSString *firstStr = arr.firstObject;
        NSArray *list = [firstStr componentsSeparatedByString:@"/"];
        judgeStr = list.lastObject;
    }
    for (NSString *video in fileList) {
        if (video.length>0&&judgeStr.length>0&&[video rangeOfString:judgeStr].location!=NSNotFound) {
            videoPath = [NSString stringWithFormat:@"%@/%@",string,video];
            break;
        }
    }
    
    return videoPath;
    
}

+(void)deleteAllMp4Data{
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *fileList = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:string error:nil] pathsMatchingExtensions:@[@"mp4"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *mp4 in fileList) {
        NSString *path = [NSString stringWithFormat:@"%@/%@",string,mp4];
        [fileManager removeItemAtPath:path error:nil];
    }
}
@end
