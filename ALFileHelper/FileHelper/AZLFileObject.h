//
//  AZLFileObject.h
//  ALExampleTest
//
//  Created by yangming on 2018/9/19.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, AZLFileType) {
    AZLFileTypeFile,
    AZLFileTypeFolder,
    AZLFileTypeNotExist,
};
@interface AZLFileObject : NSObject

//完整路徑
@property (nonatomic, copy) NSString *fullPath;

//名字
@property (nonatomic, strong) NSString *name;

//文件類型
@property (nonatomic, assign) AZLFileType type;

//文件修改時間
@property (nonatomic, strong) NSDate *modifyDate;

//所有下一級文件
@property (nonatomic, copy) NSArray<AZLFileObject *> *subPaths;

@end
