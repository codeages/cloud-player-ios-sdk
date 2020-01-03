//
//  ESDefaultVideoControlView.m
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/30.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "ESDefaultVideoControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry/Masonry.h>
#import "ESVideoPlayerSlider.h"
#import "UIView+Fade.h"
#import "UIView+MMLayout.h"
#import "ESPopoverView.h"

#define MODEL_TAG_BEGIN 20
#define BOTTOM_IMAGE_VIEW_HEIGHT 50
#define VideoPlayerImage(file)              [UIImage imageNamed:file]

@interface ESDefaultVideoControlView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UILabel                 *titleLabel;
@property (nonatomic, strong) UILabel                 *previewLabel;
@property (nonatomic, strong) UILabel                 *tipLabel;
@property (nonatomic, strong) UIButton                *startBtn;
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
@property (nonatomic, strong) UILabel                 *totalTimeLabel;
@property (nonatomic, strong) UIButton                *fullScreenBtn;
@property (nonatomic, strong) UIButton                *backBtn;
@property (nonatomic, strong) UIImageView             *bottomImageView;
@property (nonatomic, strong) UIImageView             *topImageView;
@property (nonatomic, strong) UIButton                *resolutionBtn;
@property (nonatomic, strong) UIButton                *playeBtn;
@property (nonatomic, strong) UIButton                *rateBtn;
@property (nonatomic, strong) ESVideoPlayerSlider   *videoSlider;

@property (nonatomic, assign)NSTimeInterval currentDuration;
@property (nonatomic, assign)NSTimeInterval duration;
@property (nonatomic, assign)NSTimeInterval playableDuration;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

@end


@implementation ESDefaultVideoControlView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.preview = NO;
        
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        [self addSubview:self.tipLabel];

        [self.bottomImageView addSubview:self.previewLabel];
        [self.bottomImageView addSubview:self.startBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.videoSlider];
        [self.bottomImageView addSubview:self.resolutionBtn];
        [self.bottomImageView addSubview:self.rateBtn];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        
        [self.topImageView addSubview:self.backBtn];
        
        [self addSubview:self.playeBtn];
        
        [self.topImageView addSubview:self.titleLabel];
        [self makeSubViewsConstraints];
        
        self.resolutionBtn.hidden   = YES;
        self.rateBtn.hidden   = YES;
        [self playerResetControlView];
        
        
        self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
        self.singleTap.delegate                = self;
        self.singleTap.numberOfTouchesRequired = 1; //手指数
        self.singleTap.numberOfTapsRequired    = 1;
        [self addGestureRecognizer:self.singleTap];
        [self.singleTap setDelaysTouchesBegan:YES];

    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)makeSubViewsConstraints {
    [self.tipLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
           make.center.equalTo(self);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
       }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topImageView.mas_leading).offset(5);
        make.top.equalTo(self.topImageView.mas_top).offset(3);
        make.width.height.mas_equalTo(40);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backBtn.mas_trailing).offset(5);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(BOTTOM_IMAGE_VIEW_HEIGHT);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
        make.top.equalTo(self.bottomImageView.mas_top).offset(10);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startBtn.mas_trailing);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    
    [self.rateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(45);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-8);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-8);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.resolutionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(45);
        make.trailing.equalTo(self.rateBtn.mas_leading).offset(-8);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
    }];
    
    [self.previewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoSlider.mas_top).offset(-5);
        make.leading.equalTo(self.videoSlider.mas_leading);
    }];
        
    [self.playeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.center.equalTo(self);
    }];
    
}


#pragma mark - Action
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isShowingToolBar) {
            [self fadeOutToolBar];
        } else {
            [self fadeShowToolBar];
        }
    }
}

- (void)backBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewBack:)]) {
        [self.delegate controlViewBack:self];
    }
}

- (void)exitFullScreen:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewChangeScreen:withFullScreen:)]) {
        [self.delegate controlViewChangeScreen:self withFullScreen:NO];
    }
}

- (void)playBtnClick:(UIButton *)sender {
    BOOL shouldTriggerPlay = YES;
    if (self.shouldTriggerPlay) {
        shouldTriggerPlay = self.shouldTriggerPlay(self);
    }
    if (!shouldTriggerPlay) {
        return;
    }
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.delegate controlViewPlay:self];
    } else {
        [self.delegate controlViewPause:self];
    }
    [self cancelToolBarFadeOut];
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.fullScreen = !self.fullScreen;
    [self.delegate controlViewChangeScreen:self withFullScreen:YES];
    [self fadeShowToolBar];
}


- (void)moreBtnClick:(UIButton *)sender {
    self.topImageView.hidden = YES;
    self.bottomImageView.hidden = YES;
    [self cancelToolBarFadeOut];
}

- (void)resolutionBtnClick:(UIButton *)sender {
    ESPopoverView *popover = [[ESPopoverView alloc] initWithView:sender titles:self.definitions images:nil];
    popover.backColor = [UIColor colorWithWhite:1 alpha:0.5];
    popover.titleColor = [UIColor whiteColor];
    popover.selectedIndex = self.currentDefinitionIndex;
    __weak typeof(self) _self = self;
    popover.selectRowAtIndex = ^(NSInteger index) {
        __strong typeof(_self) self = _self;
        NSString *defintion = [self.definitions objectAtIndex:index];
        [self.resolutionBtn setTitle:defintion forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(controlView:switchDefinitionWithIndex:)]) {
            [self.delegate controlView:self switchDefinitionWithIndex:index];
        }
    };
    [popover show];
    [self cancelToolBarFadeOut];
}

- (void)rateBtnClick:(UIButton *)sender {
    if (self.rates.count <= 0) {
        return;
    }
    ESPopoverView *popover = [[ESPopoverView alloc] initWithView:sender titles:self.rates images:nil];
    popover.backColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    popover.titleColor = [UIColor whiteColor];
    popover.selectedTitleColor = [UIColor blackColor];
    popover.selectedIndex = self.currentRateIndex;
    __weak typeof(self) _self = self;
    popover.selectRowAtIndex = ^(NSInteger index) {
        __strong typeof(_self) self = _self;
        [self.rateBtn setTitle:self.rates[index] forState:UIControlStateNormal];
        float rate = [self.rates[index] floatValue];
        if ([self.delegate respondsToSelector:@selector(controlView:switchRate:)]) {
            [self.delegate controlView:self switchRate:rate];
        }
    };
    [popover show];
    [self cancelToolBarFadeOut];
}

- (void)progressSliderTouchBegan:(UISlider *)sender {
    self.isDragging = YES;
    [self cancelToolBarFadeOut];
}

- (void)progressSliderValueChanged:(UISlider *)sender {
    [self.delegate controlViewPreview:self where:[self durationWithPosition:sender.value]];
}

- (void)progressSliderTouchEnded:(UISlider *)sender {
    [self.delegate controlViewSeek:self where:[self durationWithPosition:sender.value]];
    self.isDragging = NO;
    [self fadeShowToolBar];
}

///   设置横的约束
- (void)setOrientationLandscapeConstraint {
    self.topImageView.alpha = 1;
    self.fullScreen             = YES;
    self.fullScreenBtn.hidden   = YES;
    self.resolutionBtn.hidden   = self.definitions.count > 0?NO:YES;
    if (self.definitions.count > self.currentDefinitionIndex) {
        NSString *defintion = [self.definitions objectAtIndex:self.currentDefinitionIndex];
        [self.resolutionBtn setTitle:defintion forState:UIControlStateNormal];
    }
    self.rateBtn.hidden   = self.rates.count > 0?NO:YES;;

    [self.backBtn setImage:[UIImage imageNamed:@"back_full"] forState:UIControlStateNormal];

    
    [self.totalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.definitions.count > 0) {
            make.trailing.equalTo(self.resolutionBtn.mas_leading);
        } else if(self.rates.count > 0){
            make.trailing.equalTo(self.rateBtn.mas_leading);
        }else{
            make.trailing.equalTo(self.bottomImageView.mas_trailing);
        }
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    
    [self.bottomImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat b = self.superview.mm_safeAreaBottomGap;
        make.height.mas_equalTo(BOTTOM_IMAGE_VIEW_HEIGHT+b);
    }];
    
    self.videoSlider.hiddenPoints = NO;
}

/// 设置竖屏的约束
- (void)setOrientationPortraitConstraint {
    self.topImageView.alpha = 0;
    if ([self showFullScreen]) {
        self.fullScreenBtn.hidden  = NO;
        self.rateBtn.hidden   = YES;
        [self.totalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.fullScreenBtn.mas_leading);
            make.centerY.equalTo(self.startBtn.mas_centerY);
            make.width.mas_equalTo(60);
        }];
    }else{
        self.fullScreenBtn.hidden  = YES;
        self.rateBtn.hidden   = NO;
        [self.totalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.rateBtn.mas_leading);
            make.centerY.equalTo(self.startBtn.mas_centerY);
            make.width.mas_equalTo(60);
        }];
    }
    
    self.fullScreen             = NO;
    self.resolutionBtn.hidden   = YES;

    [self.bottomImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(BOTTOM_IMAGE_VIEW_HEIGHT);
    }];
    
    self.videoSlider.hiddenPoints = YES;
}

#pragma mark - private 
- (NSTimeInterval)durationWithPosition:(float)position{
    NSTimeInterval time = _duration * position;
    if (time < 0) {
        time = 0;
    }
    
    if (time > _duration) {
        time = _duration;
    }
    return time;
}
- (void)fadeShowToolBar{
    [self cancelToolBarFadeOut];
    [[self.topImageView fadeShow] fadeOut:5];
    [[self.bottomImageView fadeShow] fadeOut:5];
}

- (void)fadeOutToolBar{
    [self cancelToolBarFadeOut];
    [self.topImageView fadeOut:0.2];
    [self.bottomImageView fadeOut:0.2];
}

- (BOOL)isShowingToolBar{
    return !self.topImageView.hidden || !self.bottomImageView.hidden;
}
- (void)cancelToolBarFadeOut{
    [self.topImageView cancelFadeOut];
    [self.bottomImageView cancelFadeOut];
}

- (BOOL)showFullScreen{
    return YES;
}

#pragma mark - getter setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UILabel *)previewLabel{
    if (!_previewLabel) {
        _previewLabel = [[UILabel alloc] init];
        _previewLabel.textColor = [UIColor whiteColor];
        _previewLabel.font = [UIFont systemFontOfSize:9.0];
        _previewLabel.text = @"试看";
        _previewLabel.hidden = YES;
    }
    return _previewLabel;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _tipLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:VideoPlayerImage(@"back_full") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.image                  = VideoPlayerImage(@"top_shadow");
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.image                  = VideoPlayerImage(@"bottom_shadow");
    }
    return _bottomImageView;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:VideoPlayerImage(@"play") forState:UIControlStateNormal];
        [_startBtn setImage:VideoPlayerImage(@"pause") forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (ESVideoPlayerSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[ESVideoPlayerSlider alloc] init];
        [_videoSlider setThumbImage:VideoPlayerImage(@"slider_thumb") forState:UIControlStateNormal];
        _videoSlider.minimumTrackTintColor = [UIColor redColor];
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:VideoPlayerImage(@"fullscreen") forState:UIControlStateNormal];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _fullScreenBtn.hidden = ![self showFullScreen];
    }
    return _fullScreenBtn;
}


- (UIButton *)resolutionBtn {
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _resolutionBtn.backgroundColor = [UIColor clearColor];
        [_resolutionBtn setTitle:@"清晰度" forState:UIControlStateNormal];
        [_resolutionBtn addTarget:self action:@selector(resolutionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resolutionBtn;
}

- (UIButton *)rateBtn{
    if (!_rateBtn) {
        _rateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _rateBtn.backgroundColor = [UIColor clearColor];
        [_rateBtn setTitle:@"倍速" forState:UIControlStateNormal];
        [_rateBtn addTarget:self action:@selector(rateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rateBtn;
}

- (void)setPreview:(BOOL)preview{
    [super setPreview:preview];
    _previewLabel.hidden = !preview;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    
    if ([touch.view isKindOfClass:[UISlider class]]) { // 如果在滑块上点击就不响应pan手势
        return NO;
    }
    return YES;
}

#pragma mark - public

- (void)playerResetControlView {
    self.videoSlider.value           = 0;
    self.videoSlider.progressView.progress = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.playeBtn.hidden             = YES;
    self.backgroundColor             = [UIColor clearColor];
    
}


- (void)play{
    [self setPlayState:YES];
    [self fadeShowToolBar];
}

- (void)pause{
    [self setPlayState:NO];
    [self fadeShowToolBar];
}

- (void)stop{
    [self setPlayState:NO];
    [self fadeShowToolBar];
}

- (void)needAppear{
    [self fadeShowToolBar];
}

- (void)needDisappear{
    [self fadeOutToolBar];
}

- (void)appearTips:(NSString *)tips{
    self.tipLabel.hidden = NO;
    self.tipLabel.text = tips;
}

- (void)disappearTips{
    self.tipLabel.hidden = YES;
    self.tipLabel.text = nil;
}


- (void)setProgressTime:(NSTimeInterval)currentTime
totalTime:(NSTimeInterval)totalTime
      playableTime:(NSTimeInterval)playableTime{
    _currentDuration = currentTime;
    _duration = totalTime;
    _playableDuration = playableTime;
    
    float progress = currentTime / totalTime;
    float playable = playableTime / totalTime;

    if (!self.isDragging) {
        // 更新slider
        self.videoSlider.value  = progress;
    }
    self.currentTimeLabel.text = [self stringForSeconds:currentTime];
    self.totalTimeLabel.text = [self stringForSeconds:totalTime];
    [self.videoSlider.progressView setProgress:playable animated:NO];
}


- (NSString *)stringForSeconds:(NSInteger)secs {
    long min = 60;
    long hour = 60 * min;
    
    long hours, seconds, minutes;
    hours = secs / hour;
    minutes = (secs - hours * hour) / 60;
    seconds = (NSInteger)secs % 60;
    if ( self.duration < hour ) {
        return [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
    }
    else if ( hours < 100 ) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
    }
    else {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", hours, minutes, seconds];
    }
}

- (void)setPlayState:(BOOL)state {
    self.startBtn.selected = state;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.titleLabel.text = title;
}


@end
