//
//  ESDownloadCache.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/11/26.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ESDownloadTask;
@class ESM3U8DownloadTask;
@interface ESDownloadCache : NSObject
@property (nonatomic, copy) NSString *downloadPath;
@property (nonatomic, copy) NSString *downloadFilePath;
//@property (nonatomic, copy) NSString *downloadKeyPath;
//@property (nonatomic, copy) NSString *downloadSubtitlePath;
@property (nonatomic, copy) NSString *downloadTmpPath;
@property (nonatomic, copy) NSString *watermarkFilePath;
@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy, readonly) NSString *downloadRelativePath;
@property (nonatomic, copy, readonly) NSString *downloadFileRelativePath;
@property (nonatomic, copy, readonly) NSString *downloadKeyRelativePath;

+ (NSString *)defaultDiskCachePathClosure:(NSString *)cacheName;
- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name taskClass:(Class)tcls;
- (void)createDirectory;
- (NSString *)filePath:(NSString *)fileName;
- (NSURL *)fileURL:(NSString *)fileName;
- (BOOL)fileExists:(NSString *)fileName;
- (NSString *)filePtahWithURL:(NSURL *)url;
- (NSURL *)fileURLWithURL:(NSURL *)url;
- (BOOL)fileExistsWithURL:(NSURL *)url;
- (void)clearDiskCache;

#pragma mark- retrieve
- (NSArray<__kindof ESDownloadTask *> *)retrieveTasks;
- (void)retrieveTmpFile:(ESDownloadTask *)task;
#pragma mark - store
- (void)storeTasks:(NSArray<ESDownloadTask *> *)tasks;
- (void)storeTask:(ESDownloadTask *)task;
- (void)storeTmpFile:(ESDownloadTask *)task;
- (void)updateFileName:(ESDownloadTask *)task newFileName:(NSString *)newFileName;

#pragma mark - remove
- (void)remove:(ESDownloadTask *)task completely:(BOOL)completely;
- (void)removeFile:(ESDownloadTask *)task;
/// 删除保留在本地的缓存文件
- (void)removeTmpFile:(ESDownloadTask *)task;

#pragma mark - m3u8
- (void)storeM3U8Task:(ESM3U8DownloadTask *)task;
- (void)storeM3U8Subtitle:(ESM3U8DownloadTask *)task;
- (void)storeM3U8Key:(ESM3U8DownloadTask *)task;
- (void)storeWatermark:(ESM3U8DownloadTask *)task;
@end

NS_ASSUME_NONNULL_END
