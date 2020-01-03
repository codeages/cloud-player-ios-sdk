//
//  ESMediaPlayerDispatcher.h
//  AFNetworking
//
//  Created by aaayi on 2019/10/17.
//

#import <Foundation/Foundation.h>
#import "ESVideoContollerProtocol.h"
#import "ESPPTContollerProtocol.h"
#import "ESDocumentContollerProtocol.h"
#import "ESCloudPlayerDefines.h"
NS_ASSUME_NONNULL_BEGIN


@protocol ESCloudPlayerProtocol;
@interface ESCloudPlayerView : UIView
@property (nonatomic, copy, readonly) NSString *token;
@property (nonatomic, copy, readonly) NSString *respNo;
@property (nonatomic, copy) NSDictionary *playMetas;//播放器元数据
@property (nonatomic, assign, readonly) ESCloudPlayerResourceType mediType;
@property (nonatomic, assign, readonly) UIView *videoPreviewView;
@property (nonatomic, strong, readonly) NSArray<NSDictionary *> *definitionList;
@property (nonatomic, copy) void(^resourceDeallocExeBlock)(void);
@property (nonatomic, assign) ESCloudPlayerVideoDefinition initDefinition;
@property (nonatomic, weak) id<ESCloudPlayerProtocol> delegate;

@property (readonly) id<ESVideoContollerProtocol> videoPlayerContoller;
//@property (readonly) id<ESPPTContollerProtocol> pptPlayerContoller;
@property (readonly) id<ESDocumentContollerProtocol> docPlayerContoller;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame baseURL:(NSURL * _Nullable)baseURL userId:(NSString *_Nullable)userId userName:(NSString *_Nullable)userName;
- (instancetype)initWithFrame:(CGRect)frame userId:(NSString *_Nullable)userId userName:(NSString *_Nullable)userName;


- (void)loadResourceWithToken:(NSString *)token resNo:(NSString *)resNo  specifyStartPos:(NSInteger)specifyStartPos completionHandler:(void (^ _Nullable)(NSDictionary * _Nullable playMetas, NSError * _Nullable error))completionHandler;
- (void)playM3U8FileWithPlayURL:(NSURL *)URL subtitleURL:(NSURL *)subtitleURL;
- (void)playM3U8FileWithPlayURL:(NSURL *)URL specifyStartTime:(NSTimeInterval)specifyStartTime subtitleURL:(NSURL *)subtitleURL headLength:(NSTimeInterval)headLength;
- (void)destory;

@end

@protocol ESCloudPlayerProtocol <NSObject>
@optional

- (void)mediaPlayerVideoOnPrepared:(NSArray<NSDictionary *> *)definitions;
- (void)mediaPlayerAudioOnPrepared;
- (void)mediaPlayer:(ESCloudPlayerView *)playerView documentOnPrepared:(NSDictionary *)data;

///
/// 视频 音频缓冲
///
- (void)mediaPlayerStartBuffer:(ESCloudPlayerView *)playerView;
- (void)mediaPlayerStopBuffer:(ESCloudPlayerView *)playerView error:(NSError * _Nullable)error;

- (void)mediaPlayer:(ESCloudPlayerView *)playerView durationDidChange:(NSTimeInterval)duration;
- (void)mediaPlayer:(ESCloudPlayerView *)playerView playableDurationDidChange:(NSTimeInterval)duration;
- (void)mediaPlayer:(ESCloudPlayerView *)playerView currentTimeDidChange:(NSTimeInterval)duration;

///
/// 视频、音频暂停播放
///
- (void)mediaPlayerOnPause:(ESCloudPlayerView *)playerView;

///
/// 视频、音频开始、继续播放
///
- (void)mediaPlayerOnResume:(ESCloudPlayerView *)playerView;

///
/// 视频、音频停止播放
///
- (void)mediaPlayerOnStop:(ESCloudPlayerView *)playerView reason:(ESCloudPlayerStopReason)reason;

///
/// 视频清晰度切换
///
- (void)mediaPlayer:(ESCloudPlayerView *)playerView switchDefinitionStatusDidChange:(ESCloudSwitchDefinitionStatus)status;

///
/// 资源播放出错 
///
- (void)mediaPlayer:(ESCloudPlayerView *)playerView onFail:(nonnull NSError *)error;


///
///PPT 滚动事件
///
- (void)mediaPlayer:(ESCloudPlayerView *)playerView pptScrollPageAtIndex:(NSInteger)index;

///
/// PPT 点击事件
///
- (void)mediaPlayer:(ESCloudPlayerView *)playerView pptTapPageAtIndex:(NSInteger)index;

/// document
- (void)mediaPlayerDocumentOnEnd:(ESCloudPlayerView *)playerView;
- (void)mediaPlayer:(ESCloudPlayerView *)playerView documentPagechanged:(NSInteger)index;

@end


NS_ASSUME_NONNULL_END
