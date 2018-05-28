//
//  ICSandboxHelper.h
//  BaoNaHaoParent
//
//  Created by 华峰 on 2016/10/20.
//  Copyright © 2016年 XiaoHeTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICSandboxHelper : NSObject

+ (NSString *)homePath;             // 程序主目录，可见子目录(3个):Documents、Library、tmp
+ (NSString *)appPath;              // 程序目录，不能存任何东西
+ (NSString *)docPath;              // 文档目录，需要ITUNES同步备份的数据存这里，可存放用户数据
+ (NSString *)libPrefPath;          // 配置目录，配置文件存这里
+ (NSString *)libCachePath;         // 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)tmpPath;              // 临时缓存目录，APP退出后，系统可能会删除这里的内容
+ (BOOL)hasLive:(NSString *)path;   // 判断目录是否存在，不存在则创建
+ (BOOL)isPath:(NSString *)path;    // 判断是否有该路径
+ (void)isPath:(NSString *)path contain:(void (^) (NSString* path) )contain nofind:(void (^) (NSString* path))nofind;                  // 判断是否有该路径，如果有该路径则调用contain 没有则会调用nofind

/*
 *  传入路径和文件名返回对应的路径
 *  fieldName:文件名
 *  path:文件所需要的路径
 */
+ (NSString *)homePathInField:(NSString *)fieldName path:(NSString *)path;
/*
 *  根据路径删除文件内容
 *  include: 是否包含文件
 */
+ (BOOL)removeFolderInPath:(NSString *)path;

// 判断文件大小
+ (long long) fileSizeAtPath:(NSString*) filePath;

+ (NSString *)fileSize:(NSString *)filePath;

+ (NSString *)getMMSSFromSS:(NSString *)totalTime;

@end
