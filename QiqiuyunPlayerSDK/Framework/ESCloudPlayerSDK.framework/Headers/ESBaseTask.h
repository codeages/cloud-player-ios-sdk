//
//  ESBaseTask.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/11/26.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESDownloadCommon.h"

NS_ASSUME_NONNULL_BEGIN

@class ESSessionManager;
@class ESDownloadCache;
@class ESSafeQueue;
@interface ESBaseTask : NSObject<YYModel>
@property (nonatomic, assign) ESDownloadStatus status;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURL *currentURL;
@property (nonatomic, assign) NSTimeInterval startDate;
@property (nonatomic, assign) NSTimeInterval endDate;
@property (nonatomic, assign) int64_t speed;
@property (nonatomic, assign) int64_t timeRemaining;
@property (nonatomic, copy) NSString *fileName;
@property (readonly) NSString *cacheFileName;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) dispatch_queue_t operationQueue;
@property (nonatomic, strong) ESDownloadCache *cache;
@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, weak) NSURLSession *session;
@property (weak, nonatomic) ESSessionManager *manager;
@property (nonatomic, strong) NSURLRequest *request;


@property (nonatomic, strong) ESSafeQueue *progressExecuter;
@property (nonatomic, strong) ESSafeQueue *successExecuter;
@property (nonatomic, strong) ESSafeQueue *failureExecuter;
@property (nonatomic, strong) ESSafeQueue *controlExecuter;

- (instancetype)initWithURL:(NSURL *)url headers:(NSDictionary * _Nullable)headers cache:(ESDownloadCache *)cache operationQueue:(dispatch_queue_t)operationQueue;
- (void)start;
- (void)executeHandler:(ESSafeQueue *)queue;

- (void)progress:(BOOL)onMainQueue handler:(Handler)handler;
- (void)success:(BOOL)onMainQueue handler:(Handler)handler;
- (void)failure:(BOOL)onMainQueue handler:(Handler)handler;
@end

NS_ASSUME_NONNULL_END
