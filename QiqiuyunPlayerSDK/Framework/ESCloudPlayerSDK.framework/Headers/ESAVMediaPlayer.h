//
//  ESAVMediaPlayer.h
//  ESMediaPlayerSDK_Example
//
//  Created by aaayi on 2019/10/21.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "ESAVBasePlayer.h"

NS_ASSUME_NONNULL_BEGIN
extern NSNotificationName const ESAVMediaPlayerAssetStatusDidChangeNotification;
extern NSNotificationName const ESAVMediaPlayerTimeControlStatusDidChangeNotification;
extern NSNotificationName const ESAVMediaPlayerDurationDidChangeNotification;
extern NSNotificationName const ESAVMediaPlayerPlayableDurationDidChangeNotification;
extern NSNotificationName const ESAVMediaPlayerPresentationSizeDidChangeNotification;
extern NSNotificationName const ESAVMediaPlayerPlaybackTypeDidChangeNotification;
extern NSNotificationName const ESAVMediaPlayerDidPlayToEndTimeNotification;

typedef struct {
    NSTimeInterval specifyStartTime;    ///< 初始化完成后, 跳转到指定的时间开始播放
    NSTimeInterval duration;            ///< 播放时长
    NSTimeInterval playableDuration;    ///< 已缓冲的时间
    NSTimeInterval minBufferedDuration; ///< 最小缓冲时长, 当达到最小缓冲时长后, 可能会尝试恢复播放
    CGSize presentationSize;
    float rate;
    BOOL isPlayedToEndTime;             ///< 是否播放结束
    BOOL isReplayed;                    ///< 是否重播过
    BOOL isPlayed;                      ///< 是否调用过播放
} ESAVMediaPlayerPlaybackInfo;

@interface ESAVMediaPlayer : ESAVBasePlayer
- (instancetype)initWithURL:(NSURL *)URL specifyStartTime:(NSTimeInterval)specifyStartTime options:(NSDictionary *)options;;
- (instancetype)initWithPlayerItem:(ESAVBasePlayerItem *)item specifyStartTime:(NSTimeInterval)specifyStartTime;

@property (nonatomic, readonly) ESAVMediaPlayerPlaybackInfo es_playbackInfo;

@property (nonatomic) NSTimeInterval es_minBufferedDuration;
@property (nonatomic) float es_rate;

- (void)replay;

@end

NS_ASSUME_NONNULL_END
