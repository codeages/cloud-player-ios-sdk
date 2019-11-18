//
//  ESAudioPlayerCoverView.m
//  EduSoho
//
//  Created by LiweiWang on 2016/12/16.
//  Copyright © 2016年 Kuozhi Network Technology. All rights reserved.
//

#import "ESAudioPlayerCoverView.h"
#import <YYKit/UIImageView+YYWebImage.h>
@interface ESAudioPlayerCoverView ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *audioImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) UIVisualEffectView *effectView;

@end

@implementation ESAudioPlayerCoverView
+ (NSDictionary *)parseBundleName:(NSString *)bundleName {
    NSArray *bundleData = [bundleName componentsSeparatedByString:@"."];
    if (bundleData.count == 2) {
        return @{@"name":bundleData[0], @"type":bundleData[1]};
    }
    return nil;
}

+ (ESAudioPlayerCoverView *)createdAudioPlayerCoverView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ESAudioPlayerCoverView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addAnimations];
    [self stopRotating];
    
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

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    }
    return _effectView;
}

- (void)setCoverImageUrl:(NSString *)coverImageUrl {
    _coverImageUrl = coverImageUrl;
    [_coverImageView setImageWithURL:[NSURL URLWithString:coverImageUrl] options:YYWebImageOptionShowNetworkActivity];
    [_bgImageView setImageWithURL:[NSURL URLWithString:coverImageUrl] options:YYWebImageOptionShowNetworkActivity];
    [_bgImageView addSubview:self.effectView];
}


- (void)setIsFullScreen:(BOOL)isFullScreen {
    _isFullScreen = isFullScreen;
    if (_isFullScreen) {

    } else {

    }
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
    [self resumeLayer:_coverImageView.layer];
    [self resumeLayer:_audioImage.layer];

}

- (void)stopRotating {
    [self pauseLayer:_coverImageView.layer];
    [self pauseLayer:_audioImage.layer];
}
@end
