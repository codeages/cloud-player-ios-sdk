//
//  ESM3U8DownloadInfo.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/23.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESCloudPlayerDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESM3U8DownloadInfo : NSObject
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *resNo;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) ESCloudPlayerVideoDefinition definition;
- (id)initWithFileName:(NSString *)fileName resNo:(NSString *)resNo
                 token:(NSString *)token definition:(ESCloudPlayerVideoDefinition)definition;
@end

NS_ASSUME_NONNULL_END
