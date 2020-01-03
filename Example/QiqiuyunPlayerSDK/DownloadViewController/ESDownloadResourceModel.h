//
//  ESDownloadResourceModel.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/10.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESDownloadResourceModel : NSObject
@property (copy, nonatomic) NSString *resNo;
@property (copy, nonatomic) NSString *extno;
@property (copy, nonatomic) NSString *fileName;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *type;
@property (strong, nonatomic) NSData *fileData;
@property (strong, nonatomic) NSURL *fileURL;

@property (nonatomic, copy) NSString *no;
@property (nonatomic, copy) NSString *isShare;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *processStatus;
@property (nonatomic, copy) NSString *processedTime;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSString *updatedTime;

@end

NS_ASSUME_NONNULL_END
