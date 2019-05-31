//
//  AZLFileHelper.h
//  ALExampleTest
//
//  Created by yangming on 2018/9/18.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AZLFileObject.h"

@interface AZLFileHelper : NSObject


/**
 沙盒里的說明：
 
 沙盒里默認有Document，Library，tmp文件夾
 
 Documents/
 Documents中一般保存应用程序本身产生文件数据，例如游戏进度，绘图软件的绘图等， iTunes备份和恢复的时候，会包括此目录，
 注意：在此目录下不要保存从网络上下载的文件，否则app无法上架！
 
 
 Library裡有，Caches，Preferences文件夾
 
 Library/Caches/
 此目录用来保存应用程序运行时生成的需要持久化的数据，这些数据一般存储体积比较大，又不是十分重要，比如网络请求数据等。这些数据需要用户负责删除。iTunes同步设备时不会备份该目录。
 
 Library/Preferences/
 此目录保存应用程序的所有偏好设置，iOS的Settings(设置)应用会在该目录中查找应用的设置信息。iTunes同步设备时会备份该目录
 在Preferences/下不能直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好.
 
 
 tmp/
 此目录保存应用程序运行时所需的临时数据，使用完毕后再将相应的文件从该目录删除。应用没有运行时，系统也可能会清除该目录下的文件。iTunes同步设备时不会备份该目录
 
 */

//Mark - 獲取沙盒的各種路徑

//沙盒根目錄
+ (NSString *)sandBoxPath;

//Documents/
+ (NSString *)sandBoxDocumentPath;

//Library/
+ (NSString *)sandBoxLibraryPath;

//Library/Caches/
+ (NSString *)sandBoxCachePath;

//tmp/
+ (NSString *)sandBoxTmpPath;

//創建文件夾
+ (NSString *)createFolderAtPath:(NSString *)path folderName:(NSString *)name;

//創建文件
+ (NSString *)createFileAtPath:(NSString *)path fileName:(NSString *)name;

//刪除文件或文件夾
+ (BOOL)deleteWithPath:(NSString*)path;



// 计算文件大小(單位b)
+ (unsigned long long)fileSizeAtPath:(NSString *)filePath;


// 计算整个文件夹中所有文件大小(單位b)
+ (unsigned long long)folderSizeAtPath:(NSString *)folderPath;

//獲取fileobject(為了把方便文件分層，使用一個自定義的類)，isAll為YES時，獲取所有次級路徑，為NO時只會獲取該文件夾下的文件路徑
+ (AZLFileObject *)fileObjectAtPath:(NSString *)folderPath isAll:(BOOL)isAll;

//獲取為路徑下的所有子路徑(包括其子文件夾內的)，ext不為空時只獲取.ext文件(ext為文件後綴如png等)
+ (NSArray<NSString *> *)allSubPathAtPath:(NSString*)path ext:(NSString*)ext;


//獲取mainbudle里的所有文件夾和文件的路徑(路徑不包含mainbundle的路徑，是相對路徑)
+ (NSArray<NSString *> *)allPathInMainBundle;

//獲取mainbudle里為.ext的所有文件路徑(路徑不包含mainbundle的路徑，是相對路徑，ext是文件類型如png等
+ (NSArray<NSString *> *)allPathInMainBundleWithExt:(NSString *)ext;

//獲取mainbudle里為.ext的所有文件路徑，為完整路徑
+ (NSArray<NSString *> *)allFullPathInMainBundleWithExt:(NSString *)ext;





@end
