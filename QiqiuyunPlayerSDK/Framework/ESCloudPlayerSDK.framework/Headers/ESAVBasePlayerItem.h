//
//  ESAVBasePlayerItem.h
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/21.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESAVBasePlayerItem : AVPlayerItem
- (instancetype)initWithURL:(NSURL *)URL options:(NSDictionary *)options;

+ (instancetype)playerItemWithURL:(NSURL *)URL NS_UNAVAILABLE;
+ (instancetype)playerItemWithAsset:(AVAsset *)asset NS_UNAVAILABLE;
+ (instancetype)playerItemWithAsset:(AVAsset *)asset automaticallyLoadedAssetKeys:(nullable NSArray<NSString *> *)automaticallyLoadedAssetKeys API_AVAILABLE(macos(10.9), ios(7.0), tvos(9.0), watchos(1.0)) NS_UNAVAILABLE;
- (instancetype)initWithAsset:(AVAsset *)asset NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSURL *)URL NS_UNAVAILABLE;
- (instancetype)initWithAsset:(AVAsset *)asset automaticallyLoadedAssetKeys:(nullable NSArray<NSString *> *)automaticallyLoadedAssetKeys API_AVAILABLE(macos(10.9), ios(7.0), tvos(9.0), watchos(1.0)) NS_UNAVAILABLE;

@end

@interface ESAVBasePlayerItemObserver : NSObject
- (instancetype)initWithBasePlayerItem:(ESAVBasePlayerItem *)item;
@property (nonatomic, copy, nullable) void(^statusDidChangeExeBlock)(ESAVBasePlayerItem *item);
@property (nonatomic, copy, nullable) void(^playbackLikelyToKeepUpExeBlock)(ESAVBasePlayerItem *item);
@property (nonatomic, copy, nullable) void(^playbackBufferEmptyDidChangeExeBlock)(ESAVBasePlayerItem *item);
@property (nonatomic, copy, nullable) void(^playbackBufferFullDidChangeExeBlock)(ESAVBasePlayerItem *item);
@property (nonatomic, copy, nullable) void(^loadedTimeRangesDidChangeExeBlock)(ESAVBasePlayerItem *item);
@property (nonatomic, copy, nullable) void(^presentationSizeDidChangeExeBlock)(ESAVBasePlayerItem *item);

@property (nonatomic, copy, nullable) void(^failedToPlayToEndTimeExeBlock)(ESAVBasePlayerItem *item, NSError *error);
@property (nonatomic, copy, nullable) void(^didPlayToEndTimeExeBlock)(ESAVBasePlayerItem *item);
@property (nonatomic, copy, nullable) void(^newAccessLogEntryExeBlock)(ESAVBasePlayerItem *item);
@end


NS_ASSUME_NONNULL_END
