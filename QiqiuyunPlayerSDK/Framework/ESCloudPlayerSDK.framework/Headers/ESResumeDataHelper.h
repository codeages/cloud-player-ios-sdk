//
//  ESResumeDataHelper.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/11/27.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSURLSessionResumeInfoVersion @"NSURLSessionResumeInfoVersion"
#define NSURLSessionResumeCurrentRequest  @"NSURLSessionResumeCurrentRequest"
#define NSURLSessionResumeOriginalRequest @"NSURLSessionResumeOriginalRequest"
#define NSURLSessionResumeByteRange @"NSURLSessionResumeByteRange"
#define NSURLSessionResumeInfoTempFileName @"NSURLSessionResumeInfoTempFileName"
#define NSURLSessionResumeInfoLocalPath @"NSURLSessionResumeInfoLocalPath"
#define NSURLSessionResumeBytesReceived @"NSURLSessionResumeBytesReceived"

NS_ASSUME_NONNULL_BEGIN
 NSData * correctRequestData(NSData *data);
 NSMutableDictionary *getResumeDictionary(NSData *data);
@interface ESResumeDataHelper : NSObject
+ (NSString *)getTmpFileName:(NSData *)data;
+ (NSData *)handleResumeData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
