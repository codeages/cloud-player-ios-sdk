//
//  ESUploadManager.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/17.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESUploadTask.h"
#import "ESUploadCommon.h"

NS_ASSUME_NONNULL_BEGIN
@class QNUploadManager;
@interface ESUploadManager : NSObject
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, copy) NSString *startPath;
@property (nonatomic, copy) NSString *finishPath;
@property (nonatomic, assign)ESUploadStatus status;
@property (nonatomic, assign)int64_t speed;
@property (nonatomic, assign)BOOL autoRemoveWhenCompletion;
@property (nonatomic, strong)NSProgress *progress;
@property (nonatomic, strong) NSMutableArray<__kindof ESUploadTask *> *tasks;

//内部使用
@property (nonatomic, assign)BOOL shouldRun;
@property (nonatomic, strong) QNUploadManager *qnuploadManager;

+ (instancetype)defaultManager;
- (instancetype)init;
- (instancetype)initWithBaseURL:(NSURL *)baseURL startPath:(NSString *)startPath finishPath:(NSString *)finishPath;
- (ESUploadTask *)upload:(ESUploadInfo *)info;
- (NSArray<ESUploadTask *> *)multiUpload:(NSArray<ESUploadInfo *> *)infos;
- (ESUploadTask *)fetchTaskWithFileHash:(NSString *)fileHash;

- (void)start:(NSString *)fileHash;
- (void)startWithTask:(ESUploadTask *)task;
- (void)suspend:(NSString *)fileHash handler:(UploadHandler _Nullable)handler;
- (void)cancel:(NSString *)fileHash handler:(UploadHandler _Nullable)handler;
- (void)remove:(NSString *)fileHash completely:(BOOL)completely handler:(UploadHandler _Nullable)handler;

- (void)totalStart;
- (void)totalSuspend:(UploadHandler _Nullable)handler;
- (void)totalCancel:(UploadHandler _Nullable)handler;
- (void)totalRemove:(BOOL)completely handler:(UploadHandler _Nullable)handler;

- (void)progress:(BOOL)onMainQueue handler:(UploadHandler)handler;
- (void)success:(BOOL)onMainQueue handler:(UploadHandler)handler;
- (void)failure:(BOOL)onMainQueue handler:(UploadHandler)handler;


/// 内部调用
- (void)completed;
- (void)didStart;
- (void)updateProgress;
- (void)didCancelOrRemove:(NSString *)fileHash;
- (void)refreshCaches;
- (void)removeUploadFile:(ESUploadTask *)task;
@end

NS_ASSUME_NONNULL_END
