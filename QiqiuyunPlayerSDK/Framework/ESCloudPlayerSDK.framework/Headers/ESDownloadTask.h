//
//  ESDownloadTask.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/11/26.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESBaseTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESDownloadTask : ESBaseTask

@property (strong, nonatomic) NSURLSessionDownloadTask *task;
@property (copy, nonatomic) NSString *filePath;
@property (copy, nonatomic) NSString *pathExtension;
@property (copy, nonatomic) NSString *tmpFileName;
@property (strong, nonatomic) NSURL *tmpFileURL;

- (instancetype)initWithURL:(NSURL *)url headers:(NSDictionary * _Nullable)headers cache:(ESDownloadCache *)cache fileName:(NSString *)fileName operationQueue:(dispatch_queue_t)operationQueue;

- (void)start;
- (void)suspend:(Handler _Nullable)handler;
- (void)cancel:(Handler _Nullable)handler;
- (void)remove:(Handler _Nullable)handler;
- (void)remove:(BOOL)completely handler:(Handler _Nullable)handler;

- (void)updateFileName:(NSString *)name;
- (void)updateSpeedAndTimeRemaining:(NSTimeInterval) interval;
- (void)updateTimeRemaining;

- (void)didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite: (int64_t)totalBytesExpectedToWrite;
- (void)didFinishDownloadingTo:(NSURL*)location;
- (void)didComplete:(NSURLSessionTask *)task error:(NSError *)error;
@end
NS_ASSUME_NONNULL_END
