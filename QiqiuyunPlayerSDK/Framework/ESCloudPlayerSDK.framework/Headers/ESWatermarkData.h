//
//  ESWatermarkData.h
//  ESCloudPlayerSDK
//
//  Created by kuozhi on 2020/11/16.
//

#import <Foundation/Foundation.h>
#import "ESCloudPlayerDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESWatermarkData : NSObject
- (instancetype)initWithURL:(NSURL *)URL;

/// 水印图片URL
@property (nonatomic, strong) NSURL *URL;

/// 水印位置 默认为：ESCloudPlayerWatermarkPositionCenterLeft
@property (nonatomic, assign) ESCloudPlayerWatermarkPosition position;

/// 水印大小 默认为：{80,80};
@property (nonatomic, assign) CGSize size;
@end

NS_ASSUME_NONNULL_END
