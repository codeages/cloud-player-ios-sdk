//
//  ESUploadSimulator.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/11.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESUploadSimulator.h"


static double progressStep = 0.07;

@interface ESUploadSimulator ()

@property (strong) NSTimer *timer;
@property (assign) volatile double progress;
@property (assign) NSTimeInterval progressInterval;

@end

@implementation ESUploadSimulator

#pragma mark - initialization

- (instancetype)initWithProgressInterval:(NSTimeInterval)progressInterval {
    self = [super init];
    if (self != nil) {
        self.progressInterval = progressInterval;
    }
    return self;
}

#pragma mark - methods

- (void)startDownload {
    self.progress = 0.;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.progressInterval
                                                  target:self
                                                selector:@selector(increaseProgress)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)cancelDownload {
    self.progress = 0.;
    [self.timer invalidate];
}

- (void)increaseProgress {
    if (1. - self.progress > progressStep) {
        self.progress += progressStep;
    }
    else {
        self.progress = 1.;
        [self.timer performSelector:@selector(invalidate) withObject:nil afterDelay:0];
    }
    [self.delegate simulator:self didUpdateProgress:self.progress];
}

@end
