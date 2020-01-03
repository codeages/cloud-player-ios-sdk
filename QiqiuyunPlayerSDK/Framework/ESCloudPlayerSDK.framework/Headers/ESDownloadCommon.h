//
//  Common.h
//  ESCloudPlayerSDK
//
//  Created by aaayi on 2019/11/26.
//  Copyright © 2019 aaayia. All rights reserved.
//

#ifndef Common_h
#define Common_h

typedef void(^Handler)(id t);

typedef NS_ENUM(NSUInteger, ESDownloadStatus) {
    ESDownloadStatusWaiting = 0,
    ESDownloadStatusRunning = 1,
    ESDownloadStatusSuspended = 2,
    ESDownloadStatusCanceled = 3,
    ESDownloadStatusFailed = 4,
    ESDownloadStatusRemoved = 5,
    ESDownloadStatusSucceeded = 6,

    ESDownloadStatusWillSuspend,
    ESDownloadStatusWillCancel,
    ESDownloadStatusWillRemove,
    ESDownloadStatusUnknow,
};


typedef NS_ENUM(NSUInteger, ESDownloadLogLevel) {
    ESDownloadLogLevelDetailed,
    ESDownloadLogLevelSimple,
    ESDownloadLogLevelNone,
};

#endif /* Common_h */
