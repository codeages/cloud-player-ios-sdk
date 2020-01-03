//
//  ESSafeQueue.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/11/26.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESDownloadCommon.h"
NS_ASSUME_NONNULL_BEGIN

@interface ESSafeQueue : NSObject
@property (nonatomic, copy) Handler handler;
@property (nonatomic, assign) BOOL onMainQueue;

- (instancetype)initWithOnMainQueue:(BOOL)onMainQueue handler:(Handler)handler;
- (void)execute:(id )t;
@end

NS_ASSUME_NONNULL_END
