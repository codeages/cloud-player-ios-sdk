//
//  ESUploadSimulator.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/11.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ESUploadSimulator;
@protocol ESUploadSimulatorDelegate <NSObject>

- (void)simulator:(ESUploadSimulator *)simulator didUpdateProgress:(double)progress;

@end

@interface ESUploadSimulator : NSObject

@property (nonatomic, weak) id <ESUploadSimulatorDelegate> delegate;

- (instancetype)initWithProgressInterval:(NSTimeInterval)progressInterval;

- (void)startDownload;
- (void)cancelDownload;

@end

NS_ASSUME_NONNULL_END
