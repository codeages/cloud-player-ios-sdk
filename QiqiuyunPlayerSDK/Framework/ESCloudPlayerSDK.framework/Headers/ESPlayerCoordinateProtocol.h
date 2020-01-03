//
//  ESVideoPlayerCoordinateProtocol.h
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/18.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ESVideoPlayerPlayDefines.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ESPlayerCoordinateProtocol <NSObject>
@required

- (instancetype)initWithURL:(NSURL * _Nonnull)URL isAudio:(BOOL)isAudio;
- (instancetype)initWithMedia:(id<ESMediaModelProtocol> _Nonnull)media;

@property (nonatomic) NSTimeInterval periodicTimeInterval; // default value is 0.5
@property (nonatomic, strong, readonly, nullable) NSError *error;
@property (nonatomic, weak, nullable) id<ESVideoPlayerControllerDelegate> delegate;

@property (nonatomic, strong, readonly) __kindof UIView *previewView;
@property (nonatomic, strong) id<ESMediaModelProtocol> media;
@property (nonatomic, strong) AVLayerVideoGravity videoGravity; // default value is AVLayerVideoGravityResizeAspect

// - status -
@property (nonatomic, readonly) ESAssetStatus assetStatus;
@property (nonatomic, readonly) ESPlaybackTimeControlStatus timeControlStatus;
@property (nonatomic, readonly, nullable) NSString *reasonForWaitingToPlay;

@property (nonatomic, readonly) NSTimeInterval currentTime;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) NSTimeInterval playableDuration;
@property (nonatomic, readonly) NSTimeInterval durationWatched; // 已观看的时长
@property (nonatomic, readonly) CGSize presentationSize;
@property (nonatomic, readonly) float nominalFrameRate; // 字幕速率

@property (nonatomic) float volume;
@property (nonatomic) float rate;
@property (nonatomic, getter=isMuted) BOOL muted;
@property (nonatomic) BOOL pauseWhenAppDidEnterBackground;
@property (nonatomic, readonly) BOOL isPlayedToEndTime;               ///< 是否已播放完毕

- (id)pictureInPictureController;
- (void)prepareToPlay;
- (void)replay;
- (void)refresh;
- (void)play;
- (void)pause;
- (void)stop;
- (void)seekToTime:(NSTimeInterval)secs completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;
- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^ __nullable)(BOOL))completionHandler;
- (void)switchArticulation:(id<ESMediaModelProtocol>)media;

@end

NS_ASSUME_NONNULL_END
