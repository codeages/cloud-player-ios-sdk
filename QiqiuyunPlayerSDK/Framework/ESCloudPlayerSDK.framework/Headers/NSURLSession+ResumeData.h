//
//  NSURLSession+ResumeData.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/11/27.
//  Copyright © 2019 aaayia. All rights reserved.
//


#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSURLSession (ResumeData)
- (NSURLSessionDownloadTask *)correctedDownloadTask:(NSData *)resumeData;
@end

NS_ASSUME_NONNULL_END
