//
//  ESSessionDelegate.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/11/28.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ESSessionManager;
@interface ESSessionDelegate : NSObject<NSURLSessionDownloadDelegate>
@property (weak, nonatomic) ESSessionManager *manager;

@end

NS_ASSUME_NONNULL_END
