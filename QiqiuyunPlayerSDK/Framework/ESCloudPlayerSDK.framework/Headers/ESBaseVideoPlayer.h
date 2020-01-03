//
//  ESBaseVideoPlayer.h
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/21.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESVideoPlayerPlayDefines.h"
#import <CoreMedia/CoreMedia.h>

extern NSNotificationName const _Nullable ESVideoPlayerAssetStatusDidChangeNotification;
extern NSNotificationName const _Nullable ESVideoPlayerPlaybackTimeControlStatusDidChangeNotification;
extern NSNotificationName const _Nullable ESVideoPlayerDidPlayToEndTimeNotification;

extern NSNotificationName const _Nullable ESVideoPlayerCurrentTimeDidChangeNotification;
extern NSNotificationName const _Nullable ESVideoPlayerDurationDidChangeNotification;
extern NSNotificationName const _Nullable ESVideoPlayerPlayableDurationDidChangeNotification;
extern NSNotificationName const _Nullable ESVideoPlayerPresentationSizeDidChangeNotification;
extern NSNotificationName const _Nullable ESVideoPlayerPlaybackTypeDidChangeNotification;

extern NSNotificationName const _Nullable ESVideoPlayerRateDidChangeNotification;
extern NSNotificationName const _Nullable ESVideoPlayerMutedDidChangeNotification;
extern NSNotificationName const _Nullable ESVideoPlayerVolumeDidChangeNotification;
extern NSNotificationName const _Nullable ESVideoPlayerLockedScreenDidChangeNotification;

NS_ASSUME_NONNULL_BEGIN
@protocol ESPlayerCoordinateProtocol;
@class ESVideoPlayerURLAsset;
@class ESBaseVideoPlayer;
@class ESSubtitleParser;
@protocol ESVideoPlayerDelegate <NSObject>

/// When the player is prepare to play a new asset, this method will be called.
/// 当播放器准备播放一个新的资源时, 会回调这个方法
- (void)videoPlayer:(__kindof ESBaseVideoPlayer *)videoPlayer prepareToPlay:(ESVideoPlayerURLAsset *)asset;

///
/// 播放状态改变后的回调
///
///     以下状态发生变更时将会触发该回调
///     1.  timeControlStatus
///     2.  assetStatus
///     3.  播放完毕
///
- (void)videoPlayerPlaybackStatusDidChange:(__kindof ESBaseVideoPlayer *)videoPlayer;

///
/// 播放结束
///
- (void)videoPlayerPlayedToEndTime:(__kindof ESBaseVideoPlayer *)videoPlayer ;


- (void)videoPlayer:(__kindof ESBaseVideoPlayer *)videoPlayer currentTimeDidChange:(NSTimeInterval)currentTime;
- (void)videoPlayer:(__kindof ESBaseVideoPlayer *)videoPlayer durationDidChange:(NSTimeInterval)duration;
- (void)videoPlayer:(__kindof ESBaseVideoPlayer *)videoPlayer playableDurationDidChange:(NSTimeInterval)duration;

- (void)videoPlayer:(__kindof ESBaseVideoPlayer *)videoPlayer presentationSizeDidChange:(CGSize)size;
- (void)videoPlayer:(__kindof ESBaseVideoPlayer *)videoPlayer switchArticulationStatusDidChange:(NSInteger)status;

- (void)videoPlayer:(__kindof ESBaseVideoPlayer *)videoPlayer muteChanged:(BOOL)mute;
- (void)videoPlayer:(__kindof ESBaseVideoPlayer *)videoPlayer rateChanged:(float)rate;



@end

@interface ESBaseVideoPlayer : NSObject
+ (instancetype)player;
- (instancetype)init;

@property (nonatomic, strong, readonly) __kindof UIView *view;
@property (nonatomic, weak) id <ESVideoPlayerDelegate> delegate;

///
/// 播放调度者
///
///         此模块将是对视频播放的控制, 例如播放, 暂停, 调速, 跳转等等...
///
@property (nonatomic, strong) id <ESPlayerCoordinateProtocol> playerCoordinater;

///
/// 设置资源进行播放
///
///         使用URL及相关的视图信息进行初始化
///
@property (nonatomic, strong, nullable) ESVideoPlayerURLAsset *URLAsset;

///
/// 资源销毁前的回调
///
///         可以在这里做一些记录的工作. 如播放记录(未来可能会支持)
///
@property (nonatomic, copy, nullable) void(^assetDeallocExeBlock)(__kindof ESBaseVideoPlayer *videoPlayer);

///
/// 播放出错
///
@property (nonatomic, strong, readonly, nullable) NSError *error;
///
/// 暂停或播放的控制状态
///
///         当调用了暂停时, 此时 player.timeControlStatus = .paused
///
///         当调用了播放时, 此时 将可能处于以下两种状态中的任意一个:
///                         - player.timeControlStatus = .playing
///                             正在播放中.
///
///                         - player.timeControlStatus = .waitingToPlay
///                             等待播放, 等待的原因请查看 player.reasonForWaitingToPlay
///
@property (nonatomic, readonly) ESPlaybackTimeControlStatus timeControlStatus;

///
/// 当调用了播放, 播放器未能播放处于等待状态时的原因
///
///         等待原因有以下3种状态:
///             1.未设置资源, 此时设置资源后, 当`player.assetStatus = .readyToPlay`, 播放器将自动进行播放.
///             2.可能是由于缓冲不足, 播放器在等待缓存足够时自动恢复播放, 此时可以显示loading视图.
///             3.可能是正在评估缓冲中, 这个过程会进行的很快, 不需要显示loading视图.
///
@property (nonatomic, readonly, nullable) NSString *reasonForWaitingToPlay;

///
/// 资源准备(或初始化)的状态
///
///         当未设置资源时, 此时 player.assetStatus = .unknown
///         当设置新资源时, 此时 player.assetStatus = .preparing
///         当准备好播放时, 此时 player.assetStatus = .readyToPlay
///         当初始化失败时, 此时 player.assetStatus = .failed
///
@property (nonatomic, readonly) ESAssetStatus assetStatus;
///
/// 设置 进入后台时, 是否暂停播放. 默认为 YES.
///
/// 关于后台播放视频, 引用自: https://juejin.im/post/5a38e1a0f265da4327185a26
///
/// 当您想在后台播放视频时:
/// 1. 需要设置 videoPlayer.pauseWhenAppDidEnterBackground = NO; (该值默认为YES, 即App进入后台默认暂停).
/// 2. 前往 `TARGETS` -> `Capability` -> enable `Background Modes` -> select this mode `Audio, AirPlay, and Picture in Picture`
///
@property (nonatomic, assign) BOOL pauseWhenAppDidEnterBackground;
@property (nonatomic, assign) BOOL autoplayWhenSetNewAsset;                    ///< 设置新的资源后, 是否自动调用播放. 默认为 YES
@property (nonatomic, assign) BOOL resumePlaybackWhenAppDidEnterForeground;    ///< 进入前台时, 是否恢复播放. 默认为 NO
@property (nonatomic, assign) BOOL resumePlaybackWhenPlayerHasFinishedSeeking; ///< 当`seekToTime:`操作完成后, 是否恢复播放. 默认为 YES

- (void)play;       ///< 使播放
- (void)pause;      ///< 使暂停
- (void)refresh;    ///< 刷新当前资源, 将重新初始化当前的资源, 适合播放失败时调用
- (void)replay;     ///< 重播, 适合播放完毕后调用进行重播
- (void)stop;       ///< 使停止, 请注意: 当前资源将会被清空, 如需重播, 请重新设置新资源

@property (nonatomic, getter=isMuted) BOOL muted;                                   ///< 是否禁音
@property (nonatomic) float playerVolume;                                           ///< 设置播放声音
@property (nonatomic) float rate;                                                   ///< 设置播放速率

@property (nonatomic, readonly) NSTimeInterval currentTime;                         ///< 当前播放到的时间
@property (nonatomic, readonly) NSTimeInterval duration;                            ///< 总时长
@property (nonatomic, readonly) NSTimeInterval playableDuration;                    ///< 缓冲到的时间
@property (nonatomic, readonly) NSTimeInterval durationWatched;                     ///< 已观看的时长(当前资源)

@property (nonatomic, readonly) BOOL isPlayedToEndTime;                             ///< 当前资源是否已播放结束
@property (nonatomic, readonly) BOOL isPlaying;                                    ///< 正在播放
- (NSString *)stringForSeconds:(NSInteger)secs;                                     ///< 转换时间为字符串, format: 00:00:00


///
///  视频指纹
/// @param fpText 指纹文字
/// @param fTime 指纹每次显示的时间
///
- (void)showFingerprint:(NSString *)fpText fadeTime:(NSTimeInterval)fTime;

///
/// 视频水印
/// @param imageURL 水印图片URL
/// @param position 水印位置 参考  QiqiuyunPlayerWatermarkPosition
///
- (void)showWatermarkWithImageURL:(NSURL * _Nullable)imageURL position:(NSInteger)position;


/// 准备显示字幕
- (void)prepareShowSubtitle:(ESSubtitleParser *)parser;
/// 显示字幕
- (void)showSubtitle:(NSTimeInterval)time;

///
/// 跳转到指定位置播放
///
- (void)seekToTime:(NSTimeInterval)secs completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;
- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;
///
/// 切换清晰度
///
- (void)switchArticulation:(ESVideoPlayerURLAsset *)URLAsset;


/// 画中画，仅ipad支持
- (id)pictureInPictureController;

@end

NS_ASSUME_NONNULL_END
