//
//  ESVideoPlayerURLAsset.h
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/21.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESVideoPlayerPlayDefines.h"
NS_ASSUME_NONNULL_BEGIN

@interface ESVideoPlayerURLAsset : NSObject<ESMediaModelProtocol>

- (nullable instancetype)initWithURL:(NSURL *)URL specifyStartTime:(NSTimeInterval)specifyStartTime isAduio:(BOOL)isAudio;
- (nullable instancetype)initWithURL:(NSURL *)URL;

@property (nonatomic, strong, nullable) NSURL *mediaURL;
//@property (copy, nonatomic, nullable) NSString *level;

@property (assign, nonatomic, getter=isAudio) BOOL audio;
@property (nonatomic, weak, readonly, nullable) ESVideoPlayerURLAsset *originMedia;
@property (copy, nonatomic) NSString *coverImageURLString;
@property (nonatomic) NSTimeInterval specifyStartTime;
@property (nonatomic, readonly) BOOL isM3u8;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
