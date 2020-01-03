//
//  ESVideoPlayerPlayDefines.h
//  ESMediaPlayerSDK
//
//  Created by aaayi on 2019/10/21.
//  Copyright © 2019 ayia. All rights reserved.
//

#ifndef ESVideoPlayerPlayDefines_h
#define ESVideoPlayerPlayDefines_h


#ifdef DEBUG
    #define DLog(fmt, ...)  NSLog((@" \n\n  %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define DLog(...)
#endif

@protocol ESMediaModelProtocol;


typedef NS_ENUM(NSInteger, ESAssetStatus) {
    ///
    /// 未知状态
    ///
    ESAssetStatusUnknown,
    
    ///
    /// 准备中
    ///
    ESAssetStatusPreparing,
    
    ///
    /// 当前资源可随时进行播放(播放控制请查看`timeControlStatus`)
    ///
    ESAssetStatusReadyToPlay,
    
    ///
    /// 发生错误
    ///
    ESAssetStatusFailed
};

typedef NS_ENUM(NSInteger, ESPlaybackTimeControlStatus) {
    ///
    /// 暂停状态(已调用暂停或未执行任何操作的状态)
    ///
    ESPlaybackTimeControlStatusPaused,
    
    ///
    /// 播放状态(已调用播放), 当前正在缓冲或正在评估能否播放. 可以通过`reasonForWaitingToPlay`来获取原因, UI层可以根据原因来控制loading视图的状态.
    ///
    ESPlaybackTimeControlStatusWaitingToPlay,
    
    ///
    /// 播放状态(已调用播放), 当前播放器正在播放
    ///
    ESPlaybackTimeControlStatusPlaying
};

typedef NS_ENUM(NSInteger, ESArticulationSwitchStatus) {
    ESArticulationStatusUnknown = 0,
    ESArticulationStatusSwitching,
    ESArticulationStatusFinished,
    ESArticulationStatusFailed,
};

@protocol ESPlayerCoordinateProtocol;
@protocol ESVideoPlayerControllerDelegate <NSObject>

@optional
#pragma mark -
- (void)playerCoordinater:(id<ESPlayerCoordinateProtocol>)Coordinater assetStatusDidChange:(ESAssetStatus)status;
- (void)playerCoordinater:(id<ESPlayerCoordinateProtocol>)Coordinater timeControlStatusDidChange:(ESPlaybackTimeControlStatus)status;
- (void)playerCoordinater:(id<ESPlayerCoordinateProtocol>)Coordinater durationDidChange:(NSTimeInterval)duration;
- (void)playerCoordinater:(id<ESPlayerCoordinateProtocol>)Coordinater currentTimeDidChange:(NSTimeInterval)currentTime;
- (void)mediaDidPlayToEndForPlayerCoordinater:(id<ESPlayerCoordinateProtocol>)controller;
- (void)playerCoordinater:(id<ESPlayerCoordinateProtocol>)Coordinater presentationSizeDidChange:(CGSize)presentationSize;
- (void)playerCoordinater:(id<ESPlayerCoordinateProtocol>)Coordinater playableDurationDidChange:(NSTimeInterval)playableDuration;
- (void)playerCoordinater:(id<ESPlayerCoordinateProtocol>)Coordinater switchArticulationStatusDidChange:(ESArticulationSwitchStatus)status media:(id<ESMediaModelProtocol>)media;

@end

@protocol ESMediaModelProtocol
/// played by URL
@property (nonatomic, strong, nullable) NSURL *mediaURL;

@property (assign, nonatomic, getter=isAudio) BOOL audio;
/// played by other media
@property (nonatomic, weak, readonly, nullable) id<ESMediaModelProtocol> originMedia;

@property (nonatomic) NSTimeInterval specifyStartTime;

- (NSDictionary * _Nullable)options;
@end

#endif /* ESVideoPlayerPlayDefines_h */
