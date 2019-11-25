//
//  ESAudioPlayerCoverView.m
//  EduSoho
//
//  Created by LiweiWang on 2016/12/16.
//  Copyright © 2016年 Kuozhi Network Technology. All rights reserved.
//

#import "ESAudioPlayerCoverView.h"
#import <YYKit/UIImageView+YYWebImage.h>
#import <Masonry/Masonry.h>
@interface ESAudioPlayerCoverView (){
    BOOL _isRun;
}
@property (strong, nonatomic)  UIImageView *coverImageView;
@property (strong, nonatomic)  UIImageView *audioImage;
@property (strong, nonatomic)  UIImageView *bgImageView;
@property (strong, nonatomic) UIVisualEffectView *effectView;

@end

@implementation ESAudioPlayerCoverView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isRun = YES;
        [self insertSubview:self.bgImageView atIndex:0];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.bgImageView insertSubview:self.effectView atIndex:0];
        
        [self.bgImageView addSubview:self.audioImage];
        [self.bgImageView addSubview:self.coverImageView];
        [self.audioImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bgImageView);
            make.width.height.mas_equalTo(self.bgImageView.mas_width).multipliedBy(230.0f / 667.0f);
        }];
        
        [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bgImageView);
            make.width.height.mas_equalTo(self.bgImageView.mas_width).multipliedBy(214.0f / 667.0f);
        }];
        
        [self addAnimations];
        [self stopRotating];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _coverImageView.layer.cornerRadius = CGRectGetHeight(_coverImageView.frame) / 2;
    _coverImageView.layer.masksToBounds = YES;
    _effectView.frame = self.bounds;
}

- (void)dealloc{
    [_coverImageView.layer removeAllAnimations];
    [_audioImage.layer removeAllAnimations];
}

- (BOOL)showFullScreen{
    return NO;
}

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}
  
- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}


- (void)startRotating {
    if (!_isRun) {
        [self resumeLayer:_coverImageView.layer];
        [self resumeLayer:_audioImage.layer];
        _isRun  = YES;
    }
}

- (void)stopRotating {
    if (_isRun) {
        [self pauseLayer:_coverImageView.layer];
        [self pauseLayer:_audioImage.layer];
        _isRun  = NO;
    }
}


- (void)addAnimations{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(M_PI * 2);
    rotationAnimation.duration = 10.0;
    rotationAnimation.repeatCount = NSIntegerMax;
    rotationAnimation.removedOnCompletion = NO;
    [_coverImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [_audioImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


- (void)setCoverImageUrl:(NSString *)coverImageUrl {
    _coverImageUrl = coverImageUrl;
    [_coverImageView setImageWithURL:[NSURL URLWithString:coverImageUrl] options:YYWebImageOptionShowNetworkActivity];
    [_bgImageView setImageWithURL:[NSURL URLWithString:coverImageUrl] options:YYWebImageOptionShowNetworkActivity];
}

- (void)setCoverImage:(UIImage *)coverImage{
    _coverImage = coverImage;
    _coverImageView.image = coverImage;
    _bgImageView.image = coverImage;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    }
    return _effectView;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
    }
    return _bgImageView;
}

- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
    }
    return _coverImageView;
}

- (UIImageView *)audioImage{
    if (!_audioImage) {
        _audioImage = [[UIImageView alloc]init];
        _audioImage.image = [UIImage imageNamed:@"AudioImage"];
    }
    return _audioImage;
}


@end
