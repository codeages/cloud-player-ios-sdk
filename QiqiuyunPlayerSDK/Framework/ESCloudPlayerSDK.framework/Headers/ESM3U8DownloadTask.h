//
//  ESM3U8DownloadTask.h
//  ESCloudPlayerSDK_Example
//
//  Created by ayia on 2019/12/10.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESDownloadTask.h"
#import "ESCloudPlayerDefines.h"
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const ESM3U8DownloadTaskProgressNotification;
FOUNDATION_EXPORT NSString * const ESM3U8DownloadTaskSuccessNotification;
FOUNDATION_EXPORT NSString * const ESM3U8DownloadTaskFailureNotification;

@class ESMediaPlayerModel;
@class M3U8PlaylistModel;
@class ESM3U8DownloadInfo;
@interface ESM3U8DownloadTask : ESDownloadTask
@property (nonatomic, copy) NSString *resNo;
@property (nonatomic, copy) NSString *originalM3U8Text;
@property (nonatomic, copy) NSString *destinationM3U8Text;
@property (nonatomic, copy) NSString *watermarkUrl;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *keys;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *subtitles;
@property (nonatomic, assign) NSTimeInterval headLength;
@property (nonatomic, strong) ESMediaPlayerModel *originalData;
@property (nonatomic, strong) M3U8PlaylistModel *originalM3u8Model;
@property (nonatomic, strong) M3U8PlaylistModel *destinationM3u8Model;
@property (nonatomic, strong) NSData *watermarkData;
@property (nonatomic, strong) ESM3U8DownloadInfo *m3u8DownloadInfo;
@property (nonatomic, strong, readonly) NSArray<NSURL *> *subtitlesFilePath;
@property (nonatomic, strong, readonly) NSURL *watermarkFilePath;

- (instancetype)initWithURL:(NSURL *)url info:(ESM3U8DownloadInfo *)info cache:(ESDownloadCache *)cache  operationQueue:(dispatch_queue_t)operationQueue;

@property (readonly) NSString *currentMediaName;
@property (readonly) NSString *downloadM3U8FilePath;
@property (readonly) NSString *downloadM3U8MediaPath;
@property (readonly) NSString *downloadM3U8SubtitlePath;
@property (readonly) NSString *downloadM3U8KeyPath;
@property (readonly) NSString *downloadM3U8WatermarkPath;
@end

NS_ASSUME_NONNULL_END
