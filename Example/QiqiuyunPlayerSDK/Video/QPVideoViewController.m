//
//  QPVideoViewController.m
//  QiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/11/4.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "QPVideoViewController.h"
#import <QiqiuyunPlayerSDK/QiqiuyunPlayerView.h>
#import <Masonry.h>
#import "QPJWTTokenTool.h"
#import "QPRotationManager.h"
#import "ESDefaultVideoControlView.h"
#import "ESAudioPlayerCoverView.h"
#import <QMUIKit/QMUIAlertController.h>
#import <QMUIKit/QMUITextField.h>

NS_ASSUME_NONNULL_BEGIN

#define VIDEO_RES_NO @"f54d3a9a2c4c4a279b15753792e6b897"
#define VIDEO_TOKEN  @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJubyI6ImY1NGQzYTlhMmM0YzRhMjc5YjE1NzUzNzkyZTZiODk3IiwianRpIjoiYzg0MWVkNzctYTcwMy00ZiIsImV4cCI6MTYwNTA1OTMzMSwidGltZXMiOjEwMDAwMDAsInByZXZpZXciOm51bGwsIm5hdGl2ZSI6bnVsbCwicGxheUF1ZGlvIjoiMSIsImhlYWQiOm51bGwsInNraXAiOm51bGwsImVuY3J5cHQiOm51bGx9.jUrJFg4QqZ3gvfZ8OZsNASB4t0cQO8Lfg5JOCDmAEdY"

static inline __kindof UIResponder *_Nullable
_lookupResponder(UIView *view, Class cls) {
    __kindof UIResponder *_Nullable next = view.nextResponder;
    while ( next != nil && [next isKindOfClass:cls] == NO ) {
        next = next.nextResponder;
    }
    return next;
}

@interface QPVideoViewController ()<QiqiuyunPlayerProtocol,ESVideoPlayerControlViewDelegate>
@property (strong, nonatomic) QiqiuyunPlayerView *mediaPlayerView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) ESDefaultVideoControlView *controlView;
@property (strong, nonatomic) ESAudioPlayerCoverView *audioCoverView;
@property (weak, nonatomic) IBOutlet UIView *mediaContainerView;

@property (strong, nonatomic) QPRotationManager *rotationManager;
@property (strong, nonatomic) NSArray *definitions;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *resNo;
@property (strong, nonatomic)  UITextField *resNOTextField;
@property (strong, nonatomic)  UITextField *tokenTextField;

@property (assign, nonatomic) BOOL isAudio;  /// 是否是音频


@end

@implementation QPVideoViewController

- (ESDefaultVideoControlView *)controlView{
    if (!_controlView) {
        _controlView = [[ESDefaultVideoControlView alloc]initWithFrame:self.mediaContainerView.bounds];
        _controlView.rates = @[@"0.5",@"1.0",@"1.5",@"2.0"];
        _controlView.delegate = self;
        _controlView.title = @"视频";
        __weak typeof(self) _self = self;
        _controlView.shouldTriggerPlay = ^BOOL(ESVideoPlayerControlView * _Nonnull controlView) {
            __strong typeof(_self) self = _self;
            return self.mediaPlayerView.videoPlayerContoller.canPlay;
        };
    }
    return _controlView;
}

- (QiqiuyunPlayerView *)mediaPlayerView {
    if (!_mediaPlayerView) {
        _mediaPlayerView = [[QiqiuyunPlayerView alloc]initWithFrame:self.mediaContainerView.bounds];
        _mediaPlayerView.backgroundColor = [UIColor blackColor];
        _mediaPlayerView.delegate = self;
    }
    return _mediaPlayerView;
}

- (nullable __kindof UIViewController *)atViewController {
    return _lookupResponder(self.mediaPlayerView.videoPreviewView, UIViewController.class);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.token = [QPJWTTokenTool JWTTokenWithResNo:VIDEO_RES_NO playAudio:@"2"];
    self.resNo = VIDEO_RES_NO;
    self.isAudio = NO;

    [self.mediaContainerView addSubview:self.mediaPlayerView];

    QPRotationManager *rotationManager = [[QPRotationManager alloc] init];
    rotationManager.delegate = (id)self;
    _rotationManager = rotationManager;
    [self _setupRotationManager:_rotationManager];

    [self.mediaPlayerView addSubview:self.controlView];
    [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    _audioCoverView = [ESAudioPlayerCoverView createdAudioPlayerCoverView];
    _audioCoverView.coverImageUrl = @"https://pics2.baidu.com/feed/730e0cf3d7ca7bcbe4d2f6d31d0bc666f724a8ad.jpeg?token=f15c9288e3a5dc6f9e8209cb7fa83b75&s=8909B3551720C945060D6DEA0300A022";
    _audioCoverView.frame = _mediaPlayerView.bounds;
    _audioCoverView.hidden =  !self.isAudio;
    [self.mediaPlayerView addSubview:_audioCoverView];

    [self resetCoverView];

    self.resources = @[
        @{
            @"message": @"默认播放视频，可以音视频切换",
            @"resNo": @"f54d3a9a2c4c4a279b15753792e6b897",
            @"token": @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJubyI6ImY1NGQzYTlhMmM0YzRhMjc5YjE1NzUzNzkyZTZiODk3IiwianRpIjoiYzg0MWVkNzctYTcwMy00ZiIsImV4cCI6MTYwNTA1OTMzMSwidGltZXMiOjEwMDAwMDAsInByZXZpZXciOm51bGwsIm5hdGl2ZSI6bnVsbCwicGxheUF1ZGlvIjoiMSIsImhlYWQiOm51bGwsInNraXAiOm51bGwsImVuY3J5cHQiOm51bGx9.jUrJFg4QqZ3gvfZ8OZsNASB4t0cQO8Lfg5JOCDmAEdY",
        },
        @{
            @"message": @"默认播放音频，可以音视频切换",
            @"resNo": @"f54d3a9a2c4c4a279b15753792e6b897",
            @"token": @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJubyI6ImY1NGQzYTlhMmM0YzRhMjc5YjE1NzUzNzkyZTZiODk3IiwianRpIjoiMWI0Zjc2YTctNzdlYi00NCIsImV4cCI6MTYwNTA1OTMzMywidGltZXMiOjEwMDAwMDAsInByZXZpZXciOm51bGwsIm5hdGl2ZSI6bnVsbCwicGxheUF1ZGlvIjoiMiIsImhlYWQiOm51bGwsInNraXAiOm51bGwsImVuY3J5cHQiOm51bGx9.AyPN8BkTAbPZ0qVgYmu5FZtwzKD86ejNmfKxuu18MwA",
        },
        @{
            @"message": @"带水印的视频资源",
            @"resNo": @"b68c5f87101b45c898c2aef698c1b0b7",
            @"token": @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJubyI6ImI2OGM1Zjg3MTAxYjQ1Yzg5OGMyYWVmNjk4YzFiMGI3IiwianRpIjoiYzc4ZmEwZmMtMjE0OS00ZCIsImV4cCI6MTYwNTA2NDU1MywidGltZXMiOjEwMDAwMDAsInByZXZpZXciOm51bGwsIm5hdGl2ZSI6bnVsbCwicGxheUF1ZGlvIjpudWxsLCJoZWFkIjpudWxsLCJza2lwIjpudWxsLCJlbmNyeXB0IjpudWxsfQ.2HwhXgxBF7a876c8GyFNCCoHE39bolyBRBZJaDRHRr0",
        },
        @{
            @"message": @"原视频26分钟，试看5分钟",
            @"resNo": @"f54d3a9a2c4c4a279b15753792e6b897",
            @"token": @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJubyI6ImY1NGQzYTlhMmM0YzRhMjc5YjE1NzUzNzkyZTZiODk3IiwianRpIjoiMmEyNTlhNTUtMzg5Yy00MSIsImV4cCI6MTYwNDc0MDQyNSwidGltZXMiOjEwMDAwMDAsInByZXZpZXciOiIzMDAiLCJuYXRpdmUiOm51bGwsInBsYXlBdWRpbyI6bnVsbCwiaGVhZCI6bnVsbCwic2tpcCI6bnVsbCwiZW5jcnlwdCI6bnVsbH0.VYpJ-p6d0MSrk_Y38X4b37m1E3U6dBvZgiWdy8Z2N0I",
        },
        @{
            @"message": @"普通视频",
            @"resNo": @"06acd238f7344b7da68f63f04e3f068d",
            @"token": @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJubyI6IjA2YWNkMjM4ZjczNDRiN2RhNjhmNjNmMDRlM2YwNjhkIiwianRpIjoiODY4MmQ1NjYtYTQxYi00OCIsImV4cCI6MTYwNDYzNDQ1MSwidGltZXMiOjEwMDAwMDB9.YFZr95kwK1GGAlSSgIdB_kZWqGNUWld3MOHByuUaqhA",
        },
        @{
            @"message": @"严格模式",
            @"resNo": @"06acd238f7344b7da68f63f04e3f068d",
            @"token": @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJubyI6IjA2YWNkMjM4ZjczNDRiN2RhNjhmNjNmMDRlM2YwNjhkIiwianRpIjoiZTk3MzYwZWMtZDhmZC00MCIsImV4cCI6MTYwNTIzMjc0NiwidGltZXMiOjEwMDAwMDAsInByZXZpZXciOm51bGwsIm5hdGl2ZSI6bnVsbCwicGxheUF1ZGlvIjpudWxsLCJoZWFkIjpudWxsLCJza2lwIjpudWxsLCJlbmNyeXB0IjoiMyJ9.ONhOdVIjS5HxZ44--aK2F-whk7S_ZYwST1QbXo741vk",
        }
    ];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.mediaPlayerView destory];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!_rotationManager.isFullscreen) {
        self.mediaPlayerView.frame = self.mediaContainerView.bounds;
    }
}

#pragma mark - private M
- (void)_setupRotationManager:(QPRotationManager *)rotationManager {
    if (!rotationManager) return;
    rotationManager.superview = self.mediaContainerView;
    rotationManager.target = self.mediaPlayerView;
    __weak typeof(self) _self = self;
    rotationManager.shouldTriggerRotation = ^BOOL (QPRotationManager *_Nonnull mgr) {
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

    rotationManager.rotationDidStartExeBlock = ^(QPRotationManager *_Nonnull mgr) {
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

    rotationManager.targetView = ^UIView *_Nonnull (QPRotationManager *_Nonnull mgr) {
        __strong typeof(_self) self = _self;
        return self.mediaPlayerView;
    };

    rotationManager.rotationDidEndExeBlock = ^(QPRotationManager *_Nonnull mgr) {
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
        [self.rotationManager rotate:ESOrientation_Portrait animated:YES completionHandler:^(QPRotationManager *_Nonnull mgr) {
            [nav pushViewController:viewController animated:animated];
        }];
    }
}

#pragma mark -
- (void)controlViewBack:(UIView *)controlView {
    if (self.rotationManager.isFullscreen) {
        [self.rotationManager rotate];
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
    NSString *level = [self.definitions objectAtIndex:index][@"level"];
    [self.mediaPlayerView.videoPlayerContoller switchDefinition:level];
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

- (void)mediaPlayerStartBuffer:(QiqiuyunPlayerView *)playerView {
    [self showProgressInView:self.view];
}

- (void)mediaPlayerStopBuffer:(QiqiuyunPlayerView *)playerView error:(NSError *_Nullable)error {
    if (error) {
        [self showMessage:error.userInfo[@"message"]];
    }
    [self dissMissProgressInView:self.view];
}

- (void)mediaPlayerVideoOnPrepared:(NSArray<NSDictionary *> *)definitions {
    _definitions = definitions;
    NSMutableArray *titles = @[].mutableCopy;
    [definitions enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [titles addObject:obj[@"name"]];
    }];
    self.controlView.definitions = titles;
}

- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView onFail:(nonnull NSError *)error {
    [self.controlView pause];
    NSLog(@"\n\n播放错误: %@\n\n", error);
}

- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView durationDidChange:(NSTimeInterval)duration {
}

- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView playableDurationDidChange:(NSTimeInterval)duration {
    [self.controlView setProgressTime:playerView.videoPlayerContoller.currentDuration totalTime:playerView.videoPlayerContoller.duration playableTime:duration];
}

- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView switchDefinitionStatusDidChange:(QiqiuyunSwitchDefinitionStatus)status {
    switch (status) {
        case QiqiuyunSwitchDefinitionStatusSwitching: {
            [self.controlView appearTips:@"正在切换清晰度"];
        }
        break;
        case QiqiuyunSwitchDefinitionStatusFinished: {
            [self.controlView disappearTips];
            [self showMessage:@"切换成功" view:nil];
        }
        break;
        case QiqiuyunSwitchDefinitionStatusFailed: {
            [self.controlView disappearTips];
            [self showMessage:@"切换失败" view:nil];
        }
        break;
        default:
            break;
    }
}

- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView currentTimeDidChange:(NSTimeInterval)duration {
    float progress = duration / self.mediaPlayerView.videoPlayerContoller.duration;
    if (progress <= 0) {
        progress = 0.0;
    }

    if (progress > 1) {
        progress = 1.0;
    }

    [self.progressBar setProgress:progress animated:YES];
    [self.controlView setProgressTime:duration totalTime:playerView.videoPlayerContoller.duration playableTime:playerView.videoPlayerContoller.playableDuration];
}

- (void)mediaPlayerOnPause:(QiqiuyunPlayerView *)playerView {
    [self.controlView pause];
    [self.audioCoverView stopRotating];
}

- (void)mediaPlayerOnResume:(QiqiuyunPlayerView *)playerView {
    [self.controlView play];
    [self.audioCoverView startRotating];
}

- (void)mediaPlayerOnStop:(QiqiuyunPlayerView *)playerView reason:(QiqiuyunPlayerStopReason)reason{
    [self.controlView stop];
    [self.audioCoverView stopRotating];
    if (self.mediaPlayerView.videoPlayerContoller.isPreview && reason == QiqiuyunPlayerStopReasonEndTime) {
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
- (IBAction)startPlay:(id)sender {
    QMUIAlertController *aVC = [[QMUIAlertController alloc]initWithTitle:@"请输入" message:nil preferredStyle:QMUIAlertControllerStyleAlert];
    [aVC addTextFieldWithConfigurationHandler:^(QMUITextField *_Nonnull textField) {
        textField.placeholder = @"请输入respNo";
        self.resNOTextField = textField;
    }];

    [aVC addTextFieldWithConfigurationHandler:^(QMUITextField *_Nonnull textField) {
        textField.placeholder = @"请输入token";
        self.tokenTextField = textField;
    }];

    QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"确认" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *_Nonnull aAlertController, QMUIAlertAction *_Nonnull action) {
        if (_tokenTextField.text.length > 0 && _resNOTextField.text.length > 0) {
            self.token = _tokenTextField.text;
            self.resNo = _resNOTextField.text;
            [self startPlay];
        }
    }];

    QMUIAlertAction *defAction = [QMUIAlertAction actionWithTitle:@"默认播放" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *_Nonnull aAlertController, QMUIAlertAction *_Nonnull action) {
        self.token = VIDEO_TOKEN;
        self.resNo = VIDEO_RES_NO;
        [self startPlay];
    }];

    QMUIAlertAction *cAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController *_Nonnull aAlertController, QMUIAlertAction *_Nonnull action) {
    }];

    [aVC addAction:action];
    [aVC addAction:defAction];
    [aVC addAction:cAction];
    [aVC showWithAnimated:YES];
}

- (void)startPlay {
//    token = [ESJWTTokenTool JWTTokenWithResNo:respNO playAudio:@"1"];
    [self showProgressInView:self.view];
    __weak typeof(self) _self = self;
    [self.mediaPlayerView loadResourceWithToken:self.token resNo:self.resNo completionHandler:^(NSDictionary *_Nullable resource, NSError *_Nullable error) {
        __strong typeof(_self) self = _self;
        [self dissMissProgressInView:self.view];
        if (error) {
            [self showMessage:error.userInfo[@"message"]];
        } else {
            NSLog(@"%@", resource);
            self.controlView.preview = self.mediaPlayerView.videoPlayerContoller.isPreview;
            self.isAudio = [resource[@"args"][@"playlistType"] isEqualToString:@"audio"];
            [self resetCoverView];
        }
    }];
}

- (IBAction)toggleClick:(id)sender {
    if (!self.mediaPlayerView.videoPlayerContoller.canToggle) {
        return;
    }
    [self showProgressInView:self.view];
    __weak typeof(self) _self = self;
    [self.mediaPlayerView.videoPlayerContoller toggleWithCompletionHandler:^(NSDictionary *_Nullable resource, NSError *_Nullable error) {
        __strong typeof(_self) self = _self;
        [self dissMissProgressInView:self.view];
        if (error) {
            [self showMessage:error.userInfo[@"message"] view:nil];
        } else {
            NSLog(@"%@", resource);
            self.isAudio = [resource[@"args"][@"playlistType"] isEqualToString:@"audio"];
            [self resetCoverView];
        }
    }];
}

- (IBAction)resourceSelect:(id)sender {
    [self showResourceList:^(NSDictionary *_Nonnull resource) {
        self.token = resource[@"token"];
        self.resNo = resource[@"resNo"];
        [self startPlay];
    }];
}

- (IBAction)sub:(id)sender {
    NSTimeInterval toTime = self.mediaPlayerView.videoPlayerContoller.currentDuration - 5;
    if (toTime < 0) {
        toTime = 0.0;
    }
    [self.mediaPlayerView.videoPlayerContoller seekToTime:toTime completionHandler:^(BOOL finished) {
    }];
}

- (IBAction)add:(id)sender {
    NSTimeInterval toTime = self.mediaPlayerView.videoPlayerContoller.currentDuration + 5;
    if (toTime > self.mediaPlayerView.videoPlayerContoller.duration) {
        toTime = self.mediaPlayerView.videoPlayerContoller.duration;
    }
    [self.mediaPlayerView.videoPlayerContoller seekToTime:toTime completionHandler:^(BOOL finished) {
    }];
}

- (IBAction)pauseClick:(id)sender {
    [self.mediaPlayerView.videoPlayerContoller pause];
}

- (IBAction)stopClick:(id)sender {
    [self.mediaPlayerView.videoPlayerContoller stop];
}

- (IBAction)playClick:(id)sender {
    [self.mediaPlayerView.videoPlayerContoller play];
}

- (IBAction)showFingerprint {
    [self.mediaPlayerView.videoPlayerContoller showFingerprint:@"edusoho.com" fadeTime:5.0];
}

- (IBAction)showWatermark {
    [self.mediaPlayerView.videoPlayerContoller showWatermarkWithImageURL:[NSURL URLWithString:@"https://edusoho.cn/bundles/topxiaweb/v2/img/logo.png?v3.20.4"]];
}

NS_ASSUME_NONNULL_END
@end
