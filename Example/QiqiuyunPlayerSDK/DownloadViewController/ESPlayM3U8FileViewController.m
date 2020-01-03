//
//  ESPlayM3U8FileViewController.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/3.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESPlayM3U8FileViewController.h"
#import "ESDefaultVideoControlView.h"
#import "ESAudioPlayerCoverView.h"
#import "ESRotationManager.h"
#import "ESVideoViewController.h"

#import "ESAppDelegate.h"
#import <ESCloudPlayerSDK/ESMediaPlayerModel.h>

static inline __kindof UIResponder * _Nullable
_lookupResponder(UIView *view, Class cls)
{
    __kindof UIResponder *_Nullable next = view.nextResponder;
    while (next != nil && [next isKindOfClass:cls] == NO)
        next = next.nextResponder;
    return next;
}

@interface ESPlayM3U8FileViewController ()<ESCloudPlayerProtocol, ESVideoPlayerControlViewDelegate>
@property (strong, nonatomic) ESCloudPlayerView *mediaPlayerView;
@property (strong, nonatomic) ESDefaultVideoControlView *controlView;
@property (strong, nonatomic) ESAudioPlayerCoverView *audioCoverView;
@property (weak, nonatomic) IBOutlet UIView *mediaContainerView;

@property (strong, nonatomic) ESRotationManager *rotationManager;
@property (strong, nonatomic) ESMediaPlayerModel *mediaModel;

@property (assign, nonatomic) BOOL isAudio;  /// 是否是音频

@property (weak, nonatomic) ESM3U8DownloadManager *m3u8Mgr;

@end

@implementation ESPlayM3U8FileViewController
- (ESDefaultVideoControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ESDefaultVideoControlView alloc]initWithFrame:self.mediaContainerView.bounds];
        _controlView.rates = @[@"0.5", @"1.0", @"1.5", @"2.0"];
        _controlView.delegate = self;
        _controlView.title = self.title;
        _controlView.hidden =  self.isAudio;
        __weak typeof(self) _self = self;
        _controlView.shouldTriggerPlay = ^BOOL (ESVideoPlayerControlView *_Nonnull controlView) {
            __strong typeof(_self) self = _self;
            return self.mediaPlayerView.videoPlayerContoller.canPlay;
        };
    }
    return _controlView;
}

- (ESAudioPlayerCoverView *)audioCoverView {
    if (!_audioCoverView) {
        _audioCoverView = [[ESAudioPlayerCoverView alloc]initWithFrame:_mediaPlayerView.bounds];
        _audioCoverView.coverImage = [UIImage imageNamed:@"music-record"];
        _audioCoverView.delegate = self;
        _audioCoverView.hidden = !self.isAudio;
        _audioCoverView.rates = @[@"0.5", @"1.0", @"1.5"];
        _audioCoverView.title = @"音频";
        __weak typeof(self) _self = self;
        _audioCoverView.shouldTriggerPlay = ^BOOL (ESVideoPlayerControlView *_Nonnull controlView) {
            __strong typeof(_self) self = _self;
            return self.mediaPlayerView.videoPlayerContoller.canPlay;
        };
    }
    return _audioCoverView;
}


- (ESCloudPlayerView *)mediaPlayerView {
    if (!_mediaPlayerView) {
        _mediaPlayerView = [[ESCloudPlayerView alloc]initWithFrame:self.mediaContainerView.bounds];
        _mediaPlayerView.backgroundColor = [UIColor blackColor];
        _mediaPlayerView.delegate = self;
        _mediaPlayerView.initDefinition = ESCloudPlayerVideoDefinitionSHD;
        __weak typeof(self) _self = self;
        _mediaPlayerView.resourceDeallocExeBlock = ^{
            __strong typeof(_self) self = _self;
        };
    }
    return _mediaPlayerView;
}

- (nullable __kindof UIViewController *)atViewController {
    return _lookupResponder(self.mediaPlayerView.videoPreviewView, UIViewController.class);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.m3u8Mgr = ((ESAppDelegate *)[UIApplication sharedApplication].delegate).m3u8Mgr;

    [self.mediaContainerView addSubview:self.mediaPlayerView];
    ESRotationManager *rotationManager = [[ESRotationManager alloc] init];
    rotationManager.delegate = (id)self;
    _rotationManager = rotationManager;
    [self _setupRotationManager:_rotationManager];

    [self.mediaPlayerView addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    [self.mediaPlayerView addSubview:self.audioCoverView];
    [self.audioCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    @weakify(self);
    [self.m3u8Mgr preparePlayM3U8FileWithResNo:self.resNo handler:^(NSURL * _Nonnull playURL, ESM3U8DownloadTask * _Nonnull task, NSError * _Nonnull error) {
        @strongify(self);
        if (!error) {
            [self.mediaPlayerView playM3U8FileWithPlayURL:playURL specifyStartTime:0 subtitleURL:task.subtitlesFilePath.firstObject headLength:task.originalData.args.headLength];
            [self.mediaPlayerView.videoPlayerContoller showWatermarkWithImageURL:task.watermarkFilePath position:ESCloudPlayerWatermarkPositionCenter];
            self.mediaModel = task.originalData;
            self.isAudio = task.originalData.mediType == ESCloudPlayerResourceTypeAudio ||  task.originalData.mediType == ESCloudPlayerResourceTypeM3U8Audio;
            [self resetCoverView];
        }else{
            NSLog(@"%@", error);
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.mediaPlayerView destory];
    [self.m3u8Mgr stopPlayM3U8FileWithHandler:^(BOOL isStop) {
        
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!_rotationManager.isFullscreen) {
        self.mediaPlayerView.frame = self.mediaContainerView.bounds;
    }
}

#pragma mark - private M
- (void)_setupRotationManager:(ESRotationManager *)rotationManager {
    if (!rotationManager) return;
    rotationManager.superview = self.mediaContainerView;
    rotationManager.target = self.mediaPlayerView;
    __weak typeof(self) _self = self;
    rotationManager.shouldTriggerRotation = ^BOOL (ESRotationManager *_Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if (!self) return NO;
        if (mgr.isFullscreen == NO) {
        }

        if (self.isAudio) {
            return NO;
        }

        if (!self.mediaPlayerView.videoPlayerContoller.canPlay) {
            return NO;
        }

        if (self.navigationController.topViewController != self) return NO;
        if (self.presentedViewController) return NO;
        return YES;
    };

    rotationManager.rotationDidStartExeBlock = ^(ESRotationManager *_Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if (!self) return;
        self.controlView.landscape = mgr.isFullscreen;
        [self controlLayerNeedAppear];

        [UIView animateWithDuration:0.0f animations:^{
        } completion:^(BOOL finished) {
            if (mgr.isFullscreen) [self needHiddenStatusBar];
            else [self needShowStatusBar];
        }];
    };

    rotationManager.targetView = ^UIView *_Nonnull (ESRotationManager *_Nonnull mgr) {
        __strong typeof(_self) self = _self;
        return self.mediaPlayerView;
    };

    rotationManager.rotationDidEndExeBlock = ^(ESRotationManager *_Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if (!self) return;
        self.controlView.landscape = mgr.isFullscreen;
        if (mgr.isFullscreen) {
            [[self atViewController] setNeedsStatusBarAppearanceUpdate];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                [[self atViewController] setNeedsStatusBarAppearanceUpdate];
            }];
        }
    };
}

- (void)controlLayerNeedAppear {
    [self.controlView needAppear];
}

/// 控制层需要隐藏
- (void)controlLayerNeedDisappear {
    [self.controlView needDisappear];
}

- (void)needShowStatusBar {
    [self.atViewController setNeedsStatusBarAppearanceUpdate];
}

- (void)needHiddenStatusBar {
    [self.atViewController setNeedsStatusBarAppearanceUpdate];
}

- (void)resetCoverView {
    self.controlView.hidden = self.isAudio;
    self.audioCoverView.hidden = !self.isAudio;
}

#pragma mark -
- (BOOL)vc_prefersStatusBarHidden {
    if (self.rotationManager.isTransitioning) return NO;

    // 全屏播放时, 使状态栏根据控制层显示或隐藏
    if (self.rotationManager.isFullscreen) return YES;

    return NO;
}

- (UIStatusBarStyle)vc_preferredStatusBarStyle {
    if (self.rotationManager.isTransitioning) return UIStatusBarStyleLightContent;

    // 全屏播放时, 使状态栏变成白色
    if (self.rotationManager.isFullscreen) return UIStatusBarStyleLightContent;
    return UIStatusBarStyleDefault;
}

- (void)vc_forwardPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UINavigationController *nav = _lookupResponder(self.view, UINavigationController.class);
    if (nav) {
        [self.rotationManager rotate:ESOrientation_Portrait animated:YES completionHandler:^(ESRotationManager *_Nonnull mgr) {
            [nav pushViewController:viewController animated:animated];
        }];
    }
}

#pragma mark -
- (void)controlViewBack:(UIView *)controlView {
    if (self.rotationManager.isFullscreen) {
        [self.rotationManager rotate];
    }else{
        [self goBack];
    }
}

- (void)controlViewPlay:(UIView *)controlView {
    [self.mediaPlayerView.videoPlayerContoller play];
}

- (void)controlViewPause:(UIView *)controlView {
    [self.mediaPlayerView.videoPlayerContoller pause];
}

- (void)controlViewChangeScreen:(UIView *)controlView withFullScreen:(BOOL)isFullScreen {
    [self.rotationManager rotate];
}

- (void)controlViewDidChangeScreen:(UIView *)controlView {
}

- (void)controlView:(ESVideoPlayerControlView *)controlView switchDefinitionWithIndex:(NSUInteger)index {
//    NSInteger definition = [[self.definitions objectAtIndex:index][@"definition"] integerValue];
//    [self.mediaPlayerView.videoPlayerContoller switchDefinition:definition];
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
//    _definitions = definitions;
//    NSMutableArray *titles = @[].mutableCopy;
//    __block NSUInteger currentDefinitionIndex = 0;
//    [definitions enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
//        [titles addObject:obj[@"name"]];
//        if ([obj[@"definition"] integerValue] == self.mediaPlayerView.videoPlayerContoller.currentDefinition) {
//            currentDefinitionIndex = idx;
//        }
//    }];
//    self.controlView.definitions = titles;
}

- (void)mediaPlayer:(ESCloudPlayerView *)playerView onFail:(nonnull NSError *)error {
    [self.controlView pause];
    [self.audioCoverView pause];
    [self showMessage:@"播放错误"];
    NSLog(@"\n\n播放错误: %@\n\n", error);
}

- (void)mediaPlayer:(ESCloudPlayerView *)playerView durationDidChange:(NSTimeInterval)duration {
}

- (void)mediaPlayer:(ESCloudPlayerView *)playerView playableDurationDidChange:(NSTimeInterval)duration {
    [self.controlView setProgressTime:playerView.videoPlayerContoller.currentDuration totalTime:playerView.videoPlayerContoller.duration playableTime:duration];
    [self.audioCoverView setProgressTime:playerView.videoPlayerContoller.currentDuration totalTime:playerView.videoPlayerContoller.duration playableTime:duration];

}

- (void)mediaPlayer:(ESCloudPlayerView *)playerView switchDefinitionStatusDidChange:(ESCloudSwitchDefinitionStatus)status {
    switch (status) {
        case ESCloudSwitchDefinitionStatusSwitching: {
            [self.controlView appearTips:@"正在切换清晰度"];
        }
        break;
        case ESCloudSwitchDefinitionStatusFinished: {
            [self.controlView disappearTips];
            [self showMessage:@"切换成功" view:nil];
        }
        break;
        case ESCloudSwitchDefinitionStatusFailed: {
            [self.controlView disappearTips];
            [self showMessage:@"切换失败" view:nil];
        }
        break;
        default:
            break;
    }
    NSLog(@"当前清晰度 %ld", (long)self.mediaPlayerView.videoPlayerContoller.currentDefinition);
}

- (void)mediaPlayer:(ESCloudPlayerView *)playerView currentTimeDidChange:(NSTimeInterval)duration {
    float progress = duration / self.mediaPlayerView.videoPlayerContoller.duration;
    if (progress <= 0) {
        progress = 0.0;
    }

    if (progress > 1) {
        progress = 1.0;
    }

    [self.controlView setProgressTime:duration totalTime:playerView.videoPlayerContoller.duration playableTime:playerView.videoPlayerContoller.playableDuration];
    
    [self.audioCoverView setProgressTime:duration totalTime:playerView.videoPlayerContoller.duration playableTime:playerView.videoPlayerContoller.playableDuration];

}

- (void)mediaPlayerOnPause:(ESCloudPlayerView *)playerView {
    [self.controlView pause];
    [self.audioCoverView pause];
    [self.audioCoverView stopRotating];
    
}

- (void)mediaPlayerOnResume:(ESCloudPlayerView *)playerView {
    [self.controlView play];
    [self.audioCoverView play];
    [self.audioCoverView startRotating];
}

- (void)mediaPlayerOnStop:(ESCloudPlayerView *)playerView reason:(ESCloudPlayerStopReason)reason{
    [self.controlView pause];
    [self.audioCoverView pause];
    [self.audioCoverView stopRotating];
    if (self.mediaPlayerView.videoPlayerContoller.isPreview) {
        [self showMessage:@"试看结束" view:nil];
    }
}

///
/// 控制器是否可以旋转
///
- (BOOL)shouldAutorotate {
    return NO;
}

///
/// 控制器旋转支持的方向
///
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 此处为设置 iPhone 某个控制器旋转支持的方向
    // - 请根据实际情况进行修改.
    if (UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() ) {
        // 如果self不支持旋转, 返回仅支持竖屏
        if (self.shouldAutorotate == NO) return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - action
- (IBAction)showFingerprint {
    [self.mediaPlayerView.videoPlayerContoller showFingerprint:@"edusoho.com" fadeTime:5.0];
}

- (IBAction)showWatermark {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"edusoho-logo" ofType:@"png"];
    NSURL *url = [NSURL URLWithString:@"https://edusoho.cn/bundles/topxiaweb/v2/img/logo.png?v3.20.4"];
    [self.mediaPlayerView.videoPlayerContoller showWatermarkWithImageURL:url position:ESCloudPlayerWatermarkPositionCenterLeft];
}

@end
