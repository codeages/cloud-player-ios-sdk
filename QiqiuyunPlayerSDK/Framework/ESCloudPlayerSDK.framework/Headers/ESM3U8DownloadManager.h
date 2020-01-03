//
//  ESM3U8DownloadManager.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/12.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESSessionManager.h"
#import "ESM3U8DownloadInfo.h"
#import "ESM3U8DownloadTask.h"
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const ESM3U8DownloadManagerReadyNotification;

@interface ESM3U8DownloadManager : ESSessionManager

- (void)downloadM3u8:(nonnull ESM3U8DownloadInfo *)info handler:(void (^)(ESM3U8DownloadTask *))handler;
- (void)multiDownloadM3u8:(nonnull NSArray<ESM3U8DownloadInfo *> *)infos handler:(void (^)(NSArray<ESM3U8DownloadTask * > *))handler;

- (void)start:(NSString *)resNo;
- (void)startWithTask:(ESM3U8DownloadTask *)task;
- (void)suspend:(NSString *)resNo handler:(Handler _Nullable)handler;
- (void)cancel:(NSString *)resNo handler:(Handler _Nullable)handler;
- (void)remove:(NSString *)resNo completely:(BOOL)completely handler:(Handler _Nullable)handler;

- (void)preparePlayM3U8FileWithResNo:(NSString *)resNo handler:(void (^)(NSURL *playURL, ESM3U8DownloadTask *task, NSError *error))handler;
- (void)stopPlayM3U8FileWithHandler:(void (^)(BOOL isStop))handler;

- (ESM3U8DownloadTask *)fetchTaskWithResNo:(NSString *)resNo;
- (void)ready:(BOOL)onMainQueue handler:(void (^)(NSString *resNo, BOOL isStop))handler;
@end

NS_ASSUME_NONNULL_END
