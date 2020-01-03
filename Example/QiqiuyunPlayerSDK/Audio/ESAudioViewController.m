//
//  ESAudioViewController.m
//  ESMediaPlayerSDK_Example
//
//  Created by aaayi on 2019/10/31.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "ESAudioViewController.h"

#import "ESAudioPlayerCoverView.h"
#import "ESJWTTokenTool.h"
#import <Masonry.h>

#define IPHONE_X \
({ BOOL isPhoneX = NO; \
   if (@available(iOS 11.0, *)) { \
       isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0; \
   } \
   (isPhoneX); })

#define AUDIO_RES_NO @"0f7db1c2099c4315816629a06847a531"

@interface ESAudioViewController ()<ESCloudPlayerProtocol, ESVideoPlayerControlViewDelegate>
@property (strong, nonatomic) ESAudioPlayerCoverView *audioCoverView;

@end

@implementation ESAudioViewController
- (ESAudioPlayerCoverView *)audioCoverView {
    if (!_audioCoverView) {
        _audioCoverView = [[ESAudioPlayerCoverView alloc]initWithFrame:self.mediaPlayerView.bounds];
        _audioCoverView.coverImage = [UIImage imageNamed:@"music-record"];
        _audioCoverView.delegate = self;
        _audioCoverView.rates = @[@"0.5", @"1.0", @"1.5"];
        _audioCoverView.title = self.title;
        __weak typeof(self) _self = self;
        _audioCoverView.shouldTriggerPlay = ^BOOL (ESVideoPlayerControlView *_Nonnull controlView) {
            __strong typeof(_self) self = _self;
            return self.mediaPlayerView.videoPlayerContoller.canPlay;
        };
    }
    return _audioCoverView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.containerView addSubview:self.mediaPlayerView];
    [self.mediaPlayerView addSubview:self.audioCoverView];
    [self.audioCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    if (!self.token) {
       self.token = [ESJWTTokenTool JWTTokenWithPlayload:self.resNo previewTime:0 headResNo:@"" isPlayAudio:YES];
    }
    [self showProgressInView:self.view];
    __weak typeof(self) _self = self;
    [self.mediaPlayerView loadResourceWithToken:self.token resNo:self.resNo specifyStartPos:0 completionHandler:^(NSDictionary * _Nullable resource, NSError * _Nullable error) {
        __strong typeof(_self) self = _self;
        [self dissMissProgressInView:self.view];
    }];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.mediaPlayerView.frame = self.containerView.bounds;
}

#pragma mark -
- (void)controlViewBack:(UIView *)controlView {
    [self goBack];
}

- (void)controlViewPlay:(UIView *)controlView {
    [self.mediaPlayerView.videoPlayerContoller play];
}

- (void)controlViewPause:(UIView *)controlView {
    [self.mediaPlayerView.videoPlayerContoller pause];
}

- (void)controlViewChangeScreen:(UIView *)controlView withFullScreen:(BOOL)isFullScreen {
    
}

- (void)controlViewDidChangeScreen:(UIView *)controlView {
    
}

- (void)controlView:(ESVideoPlayerControlView *)controlView switchRate:(float)rate {
    [self.mediaPlayerView.videoPlayerContoller setRate:rate];
}

- (void)controlViewSeek:(UIView *)controlView where:(NSTimeInterval)pos {
    [self.mediaPlayerView.videoPlayerContoller seekToTime:pos completionHandler:^(BOOL finished) {
    }];
}

- (void)controlViewPreview:(UIView *)controlView where:(NSTimeInterval)pos {
    [self.mediaPlayerView.videoPlayerContoller seekToTime:pos completionHandler:^(BOOL finished) {
    }];
}

- (void)controlView:(nonnull ESVideoPlayerControlView *)controlView switchDefinitionWithIndex:(NSUInteger)index {
    
}


#pragma mark -

- (void)mediaPlayerStartBuffer:(ESCloudPlayerView *)playerView {
    [self showProgressInView:self.view];
}

- (void)mediaPlayerStopBuffer:(ESCloudPlayerView *)playerView error:(NSError *_Nullable)error {
    if (error) {
        [self showMessage:error.userInfo[@"message"]];
    }
    [self dissMissProgressInView:self.view];
}

- (void)mediaPlayerVideoOnPrepared:(NSArray<NSDictionary *> *)definitions {
}

- (void)mediaPlayer:(ESCloudPlayerView *)playerView onFail:(nonnull NSError *)error {
    [self.audioCoverView pause];
    NSLog(@"\n\n播放错误: %@\n\n", error);
}

- (void)mediaPlayer:(ESCloudPlayerView *)playerView durationDidChange:(NSTimeInterval)duration {
}

- (void)mediaPlayer:(ESCloudPlayerView *)playerView playableDurationDidChange:(NSTimeInterval)duration {
    [self.audioCoverView setProgressTime:playerView.videoPlayerContoller.currentDuration totalTime:playerView.videoPlayerContoller.duration playableTime:duration];
    
}

- (void)mediaPlayer:(ESCloudPlayerView *)playerView currentTimeDidChange:(NSTimeInterval)duration {
    float progress = duration / self.mediaPlayerView.videoPlayerContoller.duration;
    if (progress <= 0) {
        progress = 0.0;
    }
    
    if (progress > 1) {
        progress = 1.0;
    }
    
    [self.audioCoverView setProgressTime:duration totalTime:playerView.videoPlayerContoller.duration playableTime:playerView.videoPlayerContoller.playableDuration];
    
}

- (void)mediaPlayerOnPause:(ESCloudPlayerView *)playerView {
    [self.audioCoverView pause];
    [self.audioCoverView stopRotating];
    
}

- (void)mediaPlayerOnResume:(ESCloudPlayerView *)playerView {
    [self.audioCoverView play];
    [self.audioCoverView startRotating];
}

- (void)mediaPlayerOnStop:(ESCloudPlayerView *)playerView reason:(ESCloudPlayerStopReason)reason{
    [self.audioCoverView pause];
    [self.audioCoverView stopRotating];
    if (self.mediaPlayerView.videoPlayerContoller.isPreview) {
        [self showMessage:@"试看结束" view:nil];
    }
}

- (IBAction)pausePlay:(id)sender {
    [self.mediaPlayerView.videoPlayerContoller pause];
    
}

- (IBAction)stopPlay:(id)sender {
    [self.mediaPlayerView.videoPlayerContoller stop];
}

@end
