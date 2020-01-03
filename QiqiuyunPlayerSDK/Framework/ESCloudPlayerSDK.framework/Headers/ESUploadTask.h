//
//  ESUploadTask.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/17.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESUploadCommon.h"
#import "ESUploadCommon.h"

NS_ASSUME_NONNULL_BEGIN
@class ESUploadManager;
@class QNUploadManager;
@class ESUploadInfo;
@class ESUploadStartMetadata;
@class ESSafeQueue;
@interface ESUploadTask : NSObject
@property (nonatomic, weak) ESUploadManager *manager;
@property (nonatomic, weak) QNUploadManager *qnuploadManager;

//@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy, readonly) NSString *extno;
@property (nonatomic, copy, readonly) NSString *fileHash;
@property (nonatomic, copy, readonly) NSString *fileName;
@property (nonatomic, strong, readonly) NSURL *fileURL;
@property (nonatomic, strong, readonly) NSDictionary *resp;/// 上传成功后的返回数据
@property (nonatomic, strong) ESUploadInfo *uploadInfo;
@property (nonatomic, strong) ESUploadStartMetadata *metadata;

@property (nonatomic, assign) ESUploadStatus status;
@property (nonatomic, assign) NSTimeInterval startDate;
@property (nonatomic, assign) NSTimeInterval endDate;
@property (nonatomic, assign) int64_t speed;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) dispatch_queue_t operationQueue;
@property (nonatomic, strong) NSProgress *progress;


- (void)start;
- (void)suspend:(UploadHandler)handler;
- (void)cancel:(UploadHandler)handler;
- (void)remove:(BOOL)completely handler:(UploadHandler _Nullable)handler;

- (void)progress:(BOOL)onMainQueue handler:(UploadHandler)handler;
- (void)success:(BOOL)onMainQueue handler:(UploadHandler)handler;
- (void)failure:(BOOL)onMainQueue handler:(UploadHandler)handler;

//内部使用
- (instancetype)initWithUploadInfo:(ESUploadInfo *)info operationQueue:(dispatch_queue_t)operationQueue;
- (void)updateSpeedAndTimeRemaining:(NSTimeInterval)interval;
- (void)updateTimeRemaining;
- (void)completed;

@end

NS_ASSUME_NONNULL_END
