//
//  ICSandboxHelper.m
//  BaoNaHaoParent
//
//  Created by 华峰 on 2016/10/20.
//  Copyright © 2016年 XiaoHeTechnology. All rights reserved.
//

#import "ICSandboxHelper.h"

@implementation ICSandboxHelper

+ (NSString *)homePath{
    return NSHomeDirectory();
}

+ (NSString *)appPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)docPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)libPrefPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preferences"];
}

+ (NSString *)libCachePath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)tmpPath {
    return [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
}

+ (BOOL)hasLive:(NSString *)path {
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] ) {
        
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return NO;
}

+ (BOOL)isPath:(NSString *)path {
    
    BOOL bo = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return bo;
}

// 判断是否有该路径，如果有该路径则调用contain 没有则会调用nofind
+ (void)isPath:(NSString *)path contain:(void (^) (NSString* path) )contain nofind:(void (^) (NSString* path))nofind {
    
    if ([self isPath:path]) {
        contain(path);
    } else {
        nofind(path);
    }
}

+ (BOOL)removeFolderInPath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager removeItemAtPath:path error:nil]) {
//        DLog(@"删除成功");
        return YES;
    } else {
//        DLog(@"删除失败");
        return NO;
    }
}


+ (NSString *)homePathInField:(NSString *)fieldName path:(NSString *)path{
    
    NSString *filedPath = [NSString stringWithFormat:@"%@/%@",path,fieldName];
    
    return filedPath;
    
}

//遍历文件夹获得文件夹大小，返回多少M

//+ (float ) folderSizeAtPath:(NSString*) folderPath {
//
//    NSFileManager* manager = [NSFileManager defaultManager];
//
//    if (![manager fileExistsAtPath:folderPath]) return 0;
//
//    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
//
//    NSString* fileName;
//
//    long long folderSize = 0;
//
//    while ((fileName = [childFilesEnumerator nextObject]) != nil){
//
//        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
//
//        folderSize += [self fileSizeAtPath:fileAbsolutePath];
//
//    }
//
//    return folderSize/(1024.0*1024.0);
//
//}

//单个文件的大小

+ (long long) fileSizeAtPath:(NSString*) filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


+ (NSString *)fileSize:(NSString *)filePath
{
    // 总大小
    unsigned long long size = 0;
    NSString *sizeText = nil;
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 文件属性
    NSDictionary *attrs = [mgr attributesOfItemAtPath:filePath error:nil];
    // 如果这个文件或者文件夹不存在,或者路径不正确直接返回0;
    if (attrs == nil) return @"0";
    if ([attrs.fileType isEqualToString:NSFileTypeDirectory]) { // 如果是文件夹
        // 获得文件夹的大小  == 获得文件夹中所有文件的总大小
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:filePath];
        for (NSString *subpath in enumerator) {
            // 全路径
            NSString *fullSubpath = [filePath stringByAppendingPathComponent:subpath];
            // 累加文件大小
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
            
            if (size >= pow(10, 9)) { // size >= 1GB
                sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
            } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
                sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
            } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
                sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
            } else { // 1KB > size
                sizeText = [NSString stringWithFormat:@"%lluB", size];
            }
            
        }
        return sizeText;
    } else { // 如果是文件
        size = attrs.fileSize;
        if (size >= pow(10, 9)) { // size >= 1GB
            sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
        } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
            sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
        } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
            sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
        } else { // 1KB > size
            sizeText = [NSString stringWithFormat:@"%lluB", size];
        }
        
    }
    return sizeText;
}

//传入 秒  得到 xx:xx:xx
+ (NSString *)getMMSSFrom:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
    
}

//传入 秒  得到  xx分钟xx秒
+ (NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
}

@end
