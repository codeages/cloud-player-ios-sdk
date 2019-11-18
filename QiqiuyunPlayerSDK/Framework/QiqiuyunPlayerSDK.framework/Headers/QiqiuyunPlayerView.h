//
//  ESMediaPlayerDispatcher.h
//  AFNetworking
//
//  Created by aaayi on 2019/10/17.
//

#import <Foundation/Foundation.h>
#import "QPVideoContollerProtocol.h"
#import "QPPPTContollerProtocol.h"
#import "QPDocumentContollerProtocol.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QiqiuyunPlayerResourceType) {
    QiqiuyunPlayerResourceTypeUnknow = 0,
    QiqiuyunPlayerResourceTypePPT,
    QiqiuyunPlayerResourceTypeDoc,
    QiqiuyunPlayerResourceTypeVideo,
    QiqiuyunPlayerResourceTypeAudio,
};

typedef NS_ENUM(NSInteger, QiqiuyunSwitchDefinitionStatus) {
    QiqiuyunSwitchDefinitionStatusUnknown = 0,
    QiqiuyunSwitchDefinitionStatusSwitching,
    QiqiuyunSwitchDefinitionStatusFinished,
   QiqiuyunSwitchDefinitionStatusFailed,
};

typedef NS_ENUM(NSInteger, QiqiuyunPlayerStopReason) {
    QiqiuyunPlayerStopReasonUnknown = 0,
    QiqiuyunPlayerStopReasonError,
    QiqiuyunPlayerStopReasonEndTime,
    QiqiuyunPlayerStopReasonUserStop,
};



@protocol QiqiuyunPlayerProtocol;
@interface QiqiuyunPlayerView : UIView
@property (nonatomic, copy, class) NSString *debugBaseURLPath;
@property (nonatomic, copy, readonly) NSString *token;
@property (nonatomic, copy, readonly) NSString *respNo;
@property (nonatomic, copy, readonly) NSDictionary *playMetas;//播放器元数据
@property (nonatomic, assign, readonly) QiqiuyunPlayerResourceType mediType;
@property (nonatomic, assign, readonly) UIView *videoPreviewView;
@property (nonatomic, strong, readonly) NSArray<NSDictionary *> *definitionList;
@property (nonatomic, copy) void(^resourceDeallocExeBlock)(void);
@property (nonatomic, weak) id<QiqiuyunPlayerProtocol> delegate;

@property (readonly) id<QPVideoContollerProtocol> videoPlayerContoller;
@property (readonly) id<QPPPTContollerProtocol> pptPlayerContoller;
@property (readonly) id<QPDocumentContollerProtocol> docPlayerContoller;


- (void)loadResourceWithToken:(NSString *)token resNo:(NSString *)resNo completionHandler:(void (^ _Nullable)(NSDictionary * _Nullable playMetas, NSError * _Nullable error))completionHandler;
- (void)destory;

@end

@protocol QiqiuyunPlayerProtocol <NSObject>
@optional

- (void)mediaPlayerVideoOnPrepared:(NSArray<NSDictionary *> *)definitions;
- (void)mediaPlayerAudioOnPrepared;
- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView documentOnPrepared:(NSDictionary *)data;

///
/// 视频 音频缓冲
///
- (void)mediaPlayerStartBuffer:(QiqiuyunPlayerView *)playerView;
- (void)mediaPlayerStopBuffer:(QiqiuyunPlayerView *)playerView error:(NSError * _Nullable)error;

- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView durationDidChange:(NSTimeInterval)duration;
- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView playableDurationDidChange:(NSTimeInterval)duration;
- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView currentTimeDidChange:(NSTimeInterval)duration;

///
/// 视频、音频暂停播放
///
- (void)mediaPlayerOnPause:(QiqiuyunPlayerView *)playerView;

///
/// 视频、音频开始、继续播放
///
- (void)mediaPlayerOnResume:(QiqiuyunPlayerView *)playerView;

///
/// 视频、音频停止播放
///
- (void)mediaPlayerOnStop:(QiqiuyunPlayerView *)playerView reason:(QiqiuyunPlayerStopReason)reason;

///
/// 视频清晰度切换
///
- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView switchDefinitionStatusDidChange:(QiqiuyunSwitchDefinitionStatus)status;

///
/// 资源播放出错 
///
- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView onFail:(nonnull NSError *)error;


///
///PPT 滚动事件
///
- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView pptScrollPageAtIndex:(NSInteger)index;

///
/// PPT 点击事件
///
- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView pptTapPageAtIndex:(NSInteger)index;

/// document
- (void)mediaPlayerDocumentOnEnd:(QiqiuyunPlayerView *)playerView;
- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView documentPagechanged:(NSInteger)index;

@end


NS_ASSUME_NONNULL_END
