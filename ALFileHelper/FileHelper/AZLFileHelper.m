//
//  AZLFileHelper.m
//  ALExampleTest
//
//  Created by yangming on 2018/9/18.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AZLFileHelper.h"

@implementation AZLFileHelper

+ (NSString *)sandBoxPath{
    return NSHomeDirectory();
}

+ (NSString *)sandBoxDocumentPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)sandBoxLibraryPath{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)sandBoxCachePath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)sandBoxTmpPath{
    return NSTemporaryDirectory();
}


+ (NSString *)createFolderAtPath:(NSString *)path folderName:(NSString *)name{
    NSFileManager *fileManager = [NSFileManager defaultManager];// NSFileManager 是 Foundation 框架中用来管理和操作文件、目录等文件系统相关联内容的类。
    NSString *folderPath = [path stringByAppendingPathComponent:name];
    BOOL res = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (res) {
        return folderPath;
    }else{
        return nil;
    }
}

+ (NSString *)createFileAtPath:(NSString *)path fileName:(NSString *)name{
    NSFileManager *fileManager = [NSFileManager defaultManager];// NSFileManager 是 Foundation 框架中用来管理和操作文件、目录等文件系统相关联内容的类。
    NSString *filePath = [path stringByAppendingPathComponent:name];
    BOOL res = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    if (res) {
        return filePath;
    }else{
        return nil;
    }
}


+ (BOOL)deleteWithPath:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isOK = [fileManager removeItemAtPath:path error:nil];
    return isOK;
}


// 计算文件大小
+ (unsigned long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (isExist) {
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
        return fileSize;
    } else {
        NSLog(@"file is not exist");
        return 0;
    }
}

// 计算整个文件夹中所有文件大小
+ (unsigned long long)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:folderPath];
    if (isExist) {
        NSEnumerator *childFileEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
        unsigned long long folderSize = 0;
        NSString *fileName = @"";
        while ((fileName = [childFileEnumerator nextObject]) != nil){
            NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        return folderSize;
    } else {
        NSLog(@"folder is not exist");
        return 0;
    }
}

//檢測文件類型的方法，
+ (AZLFileType)checkFileTypeWithPath:(NSString *)path{
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (!isExist) {
        return AZLFileTypeNotExist;
    }
    if (isDir) {
        return AZLFileTypeFolder;
    }
    return AZLFileTypeFile;
}

+ (AZLFileObject *)fileObjectAtPath:(NSString *)folderPath isAll:(BOOL)isAll{
    NSFileManager * fileManger = [NSFileManager defaultManager];
    AZLFileType fileType = [self checkFileTypeWithPath:folderPath];
    
    if (fileType != AZLFileTypeNotExist) {
        
        AZLFileObject *fileObject = [[AZLFileObject alloc] init];
        NSString *fileName = [[folderPath componentsSeparatedByString:@"/"] lastObject];
        
        fileObject.name = fileName;
        fileObject.fullPath = folderPath;
        fileObject.type = fileType;
        NSError *error = nil;
        NSDictionary *fileAttrs = [fileManger attributesOfItemAtPath:folderPath error:&error];
        NSDate *fileModifiedDate = [fileAttrs fileModificationDate];
        fileObject.modifyDate = fileModifiedDate;
        
        if (fileObject.type == AZLFileTypeFolder) {
            NSMutableArray *paths = [[NSMutableArray alloc] init];
            NSArray * dirArray = [fileManger contentsOfDirectoryAtPath:folderPath error:nil];
            NSString * subPath = nil;
            for (NSString * str in dirArray) {
                subPath = [folderPath stringByAppendingPathComponent:str];
                
                AZLFileObject *subObject = nil;
                if (isAll) {
                    subObject = [self fileObjectAtPath:subPath isAll:YES];
                }else{
                    subObject = [[AZLFileObject alloc] init];
                    subObject.name = str;
                    subObject.fullPath = subPath;
                    subObject.type = [self checkFileTypeWithPath:subPath];
                    NSError *subError = nil;
                    NSDictionary *subFileAttrs = [fileManger attributesOfItemAtPath:subPath error:&subError];
                    NSDate *subFileModifiedDate = [subFileAttrs fileModificationDate];
                    subObject.modifyDate = subFileModifiedDate;
                }
                
                if (subObject) {
                    [paths addObject:subObject];
                }
            }
            fileObject.subPaths = paths;
        }
        return fileObject;
    }else{
        NSLog(@"this path is not exist!");
        return nil;
    }
    
}

+ (NSArray<NSString *> *)allSubPathAtPath:(NSString*)path ext:(NSString*)ext{
    NSString *suffix = nil;
    if (ext) {
        suffix = [NSString stringWithFormat:@".%@", ext];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator;
    NSMutableArray *resourceArray = [[NSMutableArray alloc] init];
    NSString *faterPath = path;
    enumerator = [fileManager enumeratorAtPath:path];
    while((path = [enumerator nextObject]) != nil) {
        if (suffix) {
            if ([path hasSuffix:suffix]) {
                [resourceArray addObject:[faterPath stringByAppendingPathComponent:path]];
            }
        }else{
            [resourceArray addObject:[faterPath stringByAppendingPathComponent:path]];
        }
    }
    
    return resourceArray.copy;
}

+ (NSArray<NSString *> *)allPathInMainBundle{
    NSBundle *mainBundle =  [NSBundle mainBundle];
    
    //歷遍mainbundle里的所有路徑
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator;
    NSMutableArray *resourceArray = [[NSMutableArray alloc] init];
    NSString *path = mainBundle.bundlePath;
    enumerator = [fileManager enumeratorAtPath:path];
    while((path = [enumerator nextObject]) != nil) {
        //把得到的图片添加到数组中
        [resourceArray addObject:path];
    }
    
    return resourceArray.copy;
}

+ (NSArray<NSString *> *)allPathInMainBundleWithExt:(NSString *)ext{
    if (ext == nil) {
        return @[];
    }
    NSBundle *mainBundle =  [NSBundle mainBundle];
    
    NSString *suffix = [NSString stringWithFormat:@".%@", ext];
    
    //歷遍mainbundle里的所有路徑
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator;
    NSMutableArray *resourceArray = [[NSMutableArray alloc] init];
    NSString *path = mainBundle.bundlePath;
    enumerator = [fileManager enumeratorAtPath:path];
    while((path = [enumerator nextObject]) != nil) {
        if ([path hasSuffix:suffix]) {
            [resourceArray addObject:path];
        }
    }
    
    return resourceArray.copy;
}


+ (NSArray<NSString *> *)allFullPathInMainBundleWithExt:(NSString *)ext{
    if (ext == nil) {
        return @[];
    }
    NSBundle *mainBundle =  [NSBundle mainBundle];
    
    NSString *suffix = [NSString stringWithFormat:@".%@", ext];
    
    //歷遍mainbundle里的所有路徑
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator;
    NSMutableArray *resourceArray = [[NSMutableArray alloc] init];
    NSString *path = mainBundle.bundlePath;
    NSString *bundlePath = path;
    enumerator = [fileManager enumeratorAtPath:path];
    while((path = [enumerator nextObject]) != nil) {
        if ([path hasSuffix:suffix]) {
            [resourceArray addObject:[bundlePath stringByAppendingPathComponent:path]];
        }
    }
    
    return resourceArray.copy;
}

@end
