//
//  ESPlayerViewController.m
//  ESMediaPlayerSDK_Example
//
//  Created by aaayi on 2019/10/22.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "ESVideoViewController.h"

#import <Masonry.h>
#import "ESJWTTokenTool.h"
#import "ESRotationManager.h"
#import "ESDefaultVideoControlView.h"
#import "ESAudioPlayerCoverView.h"
#import <QMUIKit/QMUIAlertController.h>
#import <QMUIKit/QMUITextField.h>
#import "UINavigationBar+Edusoho.h"

NS_ASSUME_NONNULL_BEGIN

//#define VIDEO_RES_NO @"f54d3a9a2c4c4a279b15753792e6b897"
//#define VIDEO_TOKEN  @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJubyI6ImY1NGQzYTlhMmM0YzRhMjc5YjE1NzUzNzkyZTZiODk3IiwianRpIjoiYzg0MWVkNzctYTcwMy00ZiIsImV4cCI6MTYwNTA1OTMzMSwidGltZXMiOjEwMDAwMDAsInByZXZpZXciOm51bGwsIm5hdGl2ZSI6bnVsbCwicGxheUF1ZGlvIjoiMSIsImhlYWQiOm51bGwsInNraXAiOm51bGwsImVuY3J5cHQiOm51bGx9.jUrJFg4QqZ3gvfZ8OZsNASB4t0cQO8Lfg5JOCDmAEdY"

static inline __kindof UIResponder * _Nullable
_lookupResponder(UIView *view, Class cls)
{
    __kindof UIResponder *_Nullable next = view.nextResponder;
    while (next != nil && [next isKindOfClass:cls] == NO)
        next = next.nextResponder;
    return next;
}

@interface ESVideoViewController ()<ESCloudPlayerProtocol, ESVideoPlayerControlViewDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
//@property (weak, nonatomic) IBOutlet UIView *mediaContainerView;

@property (strong, nonatomic) ESDefaultVideoControlView *controlView;
@property (strong, nonatomic) ESAudioPlayerCoverView *audioCoverView;

@property (strong, nonatomic) ESRotationManager *rotationManager;
@property (strong, nonatomic) NSArray *definitions;
@property (copy, nonatomic) NSString *previewTime;
@property (copy, nonatomic) NSString *headResNo;

@property (strong, nonatomic)  UITextField *resNOTextField;
@property (strong, nonatomic)  UITextField *tokenTextField;
@property (strong, nonatomic)  UITextField *previewTimeTextField;
@property (strong, nonatomic)  UITextField *headResNoTextField;

@property (assign, nonatomic) BOOL isAudio;  /// 是否是音频

@end

@implementation ESVideoViewController

- (ESDefaultVideoControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ESDefaultVideoControlView alloc]initWithFrame:self.mediaPlayerView.bounds];
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
        _audioCoverView = [[ESAudioPlayerCoverView alloc]initWithFrame:self.containerView.bounds];
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

- (nullable __kindof UIViewController *)atViewController {
    return _lookupResponder(self.mediaPlayerView.videoPreviewView, UIViewController.class);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.isAudio = NO;
    [self.containerView addSubview:self.mediaPlayerView];

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
    [self resetCoverView];
    [self startPlay];
//    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.mediaPlayerView destory];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = YES;

//    if (@available(iOS 11.0, *)) {
//        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//    } else {
//        make.top.mas_equalTo(20 + self.navigationController.navigationBar.bounds.size.height);
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!_rotationManager.isFullscreen) {
        self.mediaPlayerView.frame = self.containerView.bounds;
    }
}

#pragma mark - private M
- (void)_setupRotationManager:(ESRotationManager *)rotationManager {
    if (!rotationManager) return;
    rotationManager.superview = self.containerView;
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
    NSInteger definition = [[self.definitions objectAtIndex:index][@"definition"] integerValue];
    [self.mediaPlayerView.videoPlayerContoller switchDefinition:definition];
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
    _definitions = definitions;
    NSMutableArray *titles = @[].mutableCopy;
    __block NSUInteger currentDefinitionIndex = 0;
    [definitions enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [titles addObject:obj[@"name"]];
        if ([obj[@"definition"] integerValue] == self.mediaPlayerView.videoPlayerContoller.currentDefinition) {
            currentDefinitionIndex = idx;
        }
    }];
    self.controlView.definitions = titles;
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
    DebugLog(@"当前清晰度 %ld", (long)self.mediaPlayerView.videoPlayerContoller.currentDefinition);
}

- (void)mediaPlayer:(ESCloudPlayerView *)playerView currentTimeDidChange:(NSTimeInterval)duration {
    float progress = duration / self.mediaPlayerView.videoPlayerContoller.duration;
    if (progress <= 0) {
        progress = 0.0;
    }

    if (progress > 1) {
        progress = 1.0;
    }

    [self.progressBar setProgress:progress animated:YES];
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
- (IBAction)startPlay:(id)sender {
    QMUIAlertController *aVC = [[QMUIAlertController alloc]initWithTitle:@"请输入" message:nil preferredStyle:QMUIAlertControllerStyleAlert];
    [aVC addTextFieldWithConfigurationHandler:^(QMUITextField *_Nonnull textField) {
        textField.placeholder = @"请输入资源No";
        self.resNOTextField = textField;
    }];

    [aVC addTextFieldWithConfigurationHandler:^(QMUITextField *_Nonnull textField) {
        textField.placeholder = @"请输入片头资源No";
        self.headResNoTextField = textField;
    }];
    
    [aVC addTextFieldWithConfigurationHandler:^(QMUITextField *_Nonnull textField) {
        textField.placeholder = @"请输入试看时间(秒)";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        self.previewTimeTextField = textField;
    }];

    [aVC addTextFieldWithConfigurationHandler:^(QMUITextField *_Nonnull textField) {
        textField.placeholder = @"请输入token(可选)";
        self.tokenTextField = textField;
    }];
    

    QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"确认" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *_Nonnull aAlertController, QMUIAlertAction *_Nonnull action) {
        if (_resNOTextField.text.length > 0) {
            if (_tokenTextField.text.length > 0) {
               self.token = _tokenTextField.text;
            }
            self.resNo = _resNOTextField.text;
            self.previewTime = self.previewTimeTextField.text;
            self.headResNo = self.headResNoTextField.text;
            [self startPlay];
        }
    }];

    QMUIAlertAction *cAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController *_Nonnull aAlertController, QMUIAlertAction *_Nonnull action) {
    }];

    [aVC addAction:action];
//    [aVC addAction:defAction];
    [aVC addAction:cAction];
    [aVC showWithAnimated:YES];
}

- (void)startPlay {
    if (self.token.length <= 0) {
        self.token = [ESJWTTokenTool JWTTokenWithPlayload:self.resNo previewTime:[self.previewTime integerValue] headResNo:self.headResNo isPlayAudio:YES];
    }
    [self showProgressInView:self.view];
    __weak typeof(self) _self = self;
    [self.mediaPlayerView loadResourceWithToken:self.token resNo:self.resNo specifyStartPos:0 completionHandler:^(NSDictionary *_Nullable resource, NSError *_Nullable error) {
        __strong typeof(_self) self = _self;
        [self dissMissProgressInView:self.view];
        if (error) {
            [self showMessage:error.userInfo[@"message"]];
        } else {
            DebugLog(@"%@", resource);
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
    [self.mediaPlayerView.videoPlayerContoller toggleWithSpecifyStartPos:30 completionHandler:^(NSDictionary *_Nullable resource, NSError *_Nullable error) {
        __strong typeof(_self) self = _self;
        [self dissMissProgressInView:self.view];
        if (error) {
            [self showMessage:error.userInfo[@"message"] view:nil];
        } else {
            DebugLog(@"%@", resource);
            self.isAudio = [resource[@"args"][@"playlistType"] isEqualToString:@"audio"];
            [self resetCoverView];
        }
    }];
}

- (IBAction)resourceSelect:(id)sender {
//    [self showResourceList:^(NSDictionary *_Nonnull resource) {
//        self.resNo = resource[@"resNo"];
//        self.headResNo = resource[@"headResNo"]?:@"";
//        self.previewTime = resource[@"previewTime"]?:@"";
//        self.token = resource[@"token"]?:@"";
//        [self startPlay];
//    }];
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"edusoho-logo" ofType:@"png"];
    NSURL *url = [NSURL URLWithString:@"https://edusoho.cn/bundles/topxiaweb/v2/img/logo.png?v3.20.4"];
    [self.mediaPlayerView.videoPlayerContoller showWatermarkWithImageURL:url position:ESCloudPlayerWatermarkPositionCenterLeft];
}

@end
NS_ASSUME_NONNULL_END
