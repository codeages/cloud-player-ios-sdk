//
//  ESSessionConfiguration.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/11/28.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESSessionConfiguration : NSObject
@property (nonatomic, assign) NSTimeInterval timeoutIntervalForRequest;
@property (nonatomic, assign) int maxConcurrentTasksLimit;
@property (nonatomic, assign) BOOL allowsCellularAccess;

@end

NS_ASSUME_NONNULL_END
