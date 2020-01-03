//
//  ESUploadInfo.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/18.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESUploadCommon.h"
NS_ASSUME_NONNULL_BEGIN

@interface ESUploadStartMetadata : NSObject
@property (nonatomic, copy) NSString *no;
@property (nonatomic, copy) NSString *extno;
@property (nonatomic, copy) NSString *uploadUrl;
@property (nonatomic, copy) NSString *uploadMode;
@property (nonatomic, copy) NSString *uploadToken;
@property (nonatomic, copy) NSString *reskey;

@end

@interface ESUploadDirectivesInfo : NSObject
@property (nonatomic, assign) NSString *output;
/// 用于Word/PDF 文档转码：转码后的格式，默认为html
@property (nonatomic, copy) NSString *type;
/// 用于PPT 动画转码：是否动画转码，默认为YES
@property (nonatomic, assign) BOOL convertAnimation;
/// 可选参数，用于视频转码：supportMobile NO不生成mp4文件，YES生成mp4文件，默认0，以支持手机浏览器兼容性问题
@property (nonatomic, assign) BOOL supportMobile;
/// 可选参数，用于视频转码：watermarks url地址，用于视频转码时生成内嵌水印的获取
@property (nonatomic, copy) NSString *watermarks;

@end

@interface ESUploadInfo : NSObject
- (instancetype)initWithFileURL:(NSURL *)fileURL fileName:(NSString *)fileName fileHash:(NSString *)fileHash;
/// 文件的沙盒路径
@property (nonatomic, strong) NSURL *fileURL;
///// 文件的hash
@property (nonatomic, copy) NSString *fileHash;
/// 文件名
@property (nonatomic, copy) NSString *name;
/// 业务系统内对应的资源编号，以便与云端资源关联
@property (nonatomic, copy) NSString *extno;
/// 资源转转码参数，如果为空则资源不转码
@property (nonatomic, strong) ESUploadDirectivesInfo *directives;
/// (form表单，chunk分片)上传方式，默认是chunk形式
@property (nonatomic, copy) NSString *uploadType;
/// 文件总大小
@property (readonly) int64_t fileSize;
@end



NS_ASSUME_NONNULL_END
