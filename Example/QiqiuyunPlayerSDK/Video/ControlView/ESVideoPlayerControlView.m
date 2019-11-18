//
//  ESVideoPlayerControlView.m
//  ESMediaPlayerSDK_Example
//
//  Created by aaayi on 2019/10/30.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "ESVideoPlayerControlView.h"

@implementation ESVideoPlayerControlView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _landscape = NO;
        _currentDefinitionIndex = 0;
        _currentRateIndex = 0;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_landscape) {
        [self setOrientationLandscapeConstraint];
    } else {
        [self setOrientationPortraitConstraint];
    }
}

- (void)setLandscape:(BOOL)landscape{
    _landscape = landscape;
    if (landscape) {
        [self setOrientationLandscapeConstraint];
    } else {
        [self setOrientationPortraitConstraint];
    }
}

- (void)play
{
}

- (void)pause
{
}

- (void)needAppear{
    
}

- (void)needDisappear{
    
}


- (void)setOrientationPortraitConstraint
{
}

- (void)setOrientationLandscapeConstraint
{
}

- (void)setPlayState:(BOOL)isPlay
{
}

- (void)setProgressTime:(NSTimeInterval)currentTime
              totalTime:(NSTimeInterval)totalTime
           playableTime:(NSTimeInterval)playableTime;
{
}

@end
