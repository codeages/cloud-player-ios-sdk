//
//  ESSessionManager.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/11/27.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESDownloadCommon.h"

NS_ASSUME_NONNULL_BEGIN
@class ESDownloadCache;
@class ESSessionConfiguration;
@class ESDownloadTask;
@class ESSafeQueue;
@interface ESSessionManager : NSObject
@property (nonatomic, class, assign)BOOL isControlNetworkActivityIndicator;
@property (nonatomic, retain)dispatch_queue_t operationQueue;

@property (nonatomic, assign) BOOL shouldCreatSession;
@property (nonatomic, assign)BOOL shouldRun;
@property (nonatomic, assign)ESDownloadStatus status;
@property (nonatomic, assign)int64_t speed;
@property (nonatomic, assign)int64_t timeRemaining;
@property (nonatomic, copy)NSString *identifier;
@property (nonatomic, copy)void(^completionHandler)(void);
@property (nonatomic, strong)ESDownloadCache *cache;
@property (nonatomic, strong)ESSessionConfiguration *configuration;
@property (nonatomic, strong)NSMutableArray<__kindof ESDownloadTask *> *tasks;
@property (nonatomic, strong)NSArray<ESDownloadTask *> *completedTasks;
@property (nonatomic, strong, nullable) NSURLSession *session;
@property (nonatomic, retain) dispatch_queue_t multiDownloadQueue;
@property (nonatomic, strong)NSProgress *progress;

@property (nonatomic, strong) ESSafeQueue *progressExecuter;
@property (nonatomic, strong) ESSafeQueue *successExecuter;
@property (nonatomic, strong) ESSafeQueue *failureExecuter;

@property (nonatomic, strong) NSMutableArray<ESDownloadTask *> *runningTasks;
@property (nonatomic, strong) NSMutableArray<ESDownloadTask *> *waitingTasks;

- (instancetype)initWithIdentifier:(NSString *)identifier configuration:(ESSessionConfiguration *)configuration operationQueue:(dispatch_queue_t)operationQueue;
- (void)invalidate;

- (ESDownloadTask *)download:(NSURL *)url;
- (ESDownloadTask *)download:(NSURL *)url header:(NSDictionary * _Nullable)header fileName:(NSString *_Nullable)fileName;
- (NSArray<ESDownloadTask *> *)multiDownload:(NSArray<NSURL *> *_Nullable)urls headers:(NSArray<NSDictionary *> *_Nullable)headers fileName:(NSArray<NSString *> *)fileNames;
- (void)multiAsyncDownload:(NSArray<NSURL *> *)urls headers:(NSArray<NSDictionary *> *)headers fileName:(NSArray<NSString *> *)fileNames handler:(void(^)(NSArray<ESDownloadTask *> * tasks))handler;
- (void)start:(NSURL *)url;
- (void)startWithTask:(ESDownloadTask *)task;
/// 暂停任务，会触发sessionDelegate的完成回调
- (void)suspend:(NSURL *)url handler:(Handler _Nullable)handler;

/// 取消任务
/// 不会对已经完成的任务造成影响
/// 其他状态的任务都可以被取消，被取消的任务会被移除
/// 会删除还没有下载完成的缓存文件
/// 会触发sessionDelegate的完成回调
- (void)cancel:(NSURL *)url handler:(Handler _Nullable)handler;

/// 移除任务
/// 所有状态的任务都可以被移除
/// 会删除还没有下载完成的缓存文件
/// 可以选择是否删除下载完成的文件
/// 会触发sessionDelegate的完成回调
///
/// - Parameters:
///   - url: URLConvertible
///   - completely: 是否删除下载完成的文件
- (void)remove:(NSURL *)url completely:(BOOL)completely handler:(Handler _Nullable)handler;
- (void)remove:(NSURL *)url handler:(Handler _Nullable)handler;

- (void)totalStart;
- (void)totalSuspend:(Handler _Nullable)handler;
- (void)totalCancel:(Handler _Nullable)handler;
- (void)totalRemove:(BOOL)completely handler:(Handler _Nullable)handler;

- (void)didStart;
- (void)updateProgress;
- (void)didCancelOrRemove:(NSURL *)url;
- (void)completed;

- (ESSessionManager *)progress:(BOOL)onMainQueue handler:(Handler)handler;
- (ESSessionManager *)success:(BOOL)onMainQueue handler:(Handler)handler;
- (ESSessionManager *)failure:(BOOL)onMainQueue handler:(Handler)handler;

- (__kindof ESDownloadTask *)fetchTaskWithURL:(NSURL *)url;
- (__kindof ESDownloadTask *)fetchTaskWithCurrentURL:(NSURL *)url;
- (void)createSession:(void (^)(void))completion;
- (void)updateStatus;
- (void)didBecomeInvalidation:(NSError *)error;
- (void)didFinishEvents:(NSURLSession *)URLSession;
- (Class)taskClass;

@end

NS_ASSUME_NONNULL_END
