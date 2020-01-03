//
//  ESUploadCommon.h
//  ESCloudPlayerSDK
//
//  Created by aaayi on 2019/12/17.
//  Copyright © 2019 aaayia. All rights reserved.
//

#ifndef ESUploadCommon_h
#define ESUploadCommon_h
typedef void(^UploadHandler)(id t);


typedef NS_ENUM(NSInteger, ESUploadFileType) {
    ESUploadFileTypeVideo,
    ESUploadFileTypeAudio,
    ESUploadFileTypeDocument,
    ESUploadFileTypePPT,
};

typedef NS_ENUM(NSUInteger, ESUploadStatus) {
    ESUploadStatusWaiting = 0,
    ESUploadStatusRunning = 1,
    ESUploadStatusSuspended = 2,
    ESUploadStatusCanceled = 3,
    ESUploadStatusFailed = 4,
    ESUploadStatusRemoved = 5,
    ESUploadStatusSucceeded = 6,

    ESUploadStatusWillSuspend,
    ESUploadStatusWillCancel,
    ESUploadStatusWillRemove,
};


#endif /* ESUploadCommon_h */
