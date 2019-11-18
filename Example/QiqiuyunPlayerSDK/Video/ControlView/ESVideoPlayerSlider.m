//
//  ESVideoPlayerSlider.m
//  ESMediaPlayerSDK_Example
//
//  Created by aaayi on 2019/10/30.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "ESVideoPlayerSlider.h"
#import <Masonry/Masonry.h>
#import "UIView+MMLayout.h"
@interface ESVideoPlayerSlider ()
@property UIImageView *tracker;
@end

@implementation ESVideoPlayerSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initUI];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self initUI];
    return self;
}

- (void)initUI {
    self.maximumValue = 1;
    self.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    self.thumbColor = [UIColor whiteColor];
    self.thumbSize = CGSizeMake(13, 13);

    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.layer.masksToBounds = YES;
    _progressView.layer.cornerRadius = 1;
    [self addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.centerY.equalTo(self).mas_offset(0.5);
        make.height.mas_equalTo(2);
    }];
    [self sendSubviewToBack:self.progressView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tracker = self.subviews.lastObject;
}

//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
//    rect.origin.x = rect.origin.x - 10;
//
//    rect.size.width = rect.size.width + 20;
//
//    return CGRectInset([super thumbRectForBounds:bounds
//                                       trackRect:rect
//                                           value:value],
//                       10,
//                       10);
//}

@end
