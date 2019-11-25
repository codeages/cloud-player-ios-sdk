//
//  ESVideoPlayerControlView.h
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/30.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ESVideoPlayerControlViewDelegate;
@interface ESVideoPlayerControlView : UIView

@property NSArray<id> *pointArray;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL preview;
@property (nonatomic, assign, getter = isLandscape) BOOL landscape;
@property (nonatomic, weak) id<ESVideoPlayerControlViewDelegate> delegate;
@property (nonatomic, strong) NSArray<NSString *> *definitions;
@property (nonatomic, assign) NSUInteger currentDefinitionIndex;
@property (nonatomic, strong) NSArray<NSString *> *rates;
@property (nonatomic, assign) NSUInteger currentRateIndex;
@property (nonatomic, copy, nullable) BOOL (^ shouldTriggerPlay)(ESVideoPlayerControlView *controlView);

- (void)setPlayState:(BOOL)isPlay;
- (void)setProgressTime:(NSTimeInterval)currentTime
              totalTime:(NSTimeInterval)totalTime
           playableTime:(NSTimeInterval)playableTime;

- (void)play;
- (void)pause;
- (void)stop;

- (void)appearTips:(NSString *)tips;
- (void)disappearTips;

- (void)needAppear;
- (void)needDisappear;

- (void)setOrientationLandscapeConstraint;
- (void)setOrientationPortraitConstraint;

@end

@protocol ESVideoPlayerControlViewDelegate <NSObject>
- (void)controlViewBack:(ESVideoPlayerControlView *)controlView;
- (void)controlViewPlay:(ESVideoPlayerControlView *)controlView;
- (void)controlViewPause:(ESVideoPlayerControlView *)controlView;
- (void)controlViewChangeScreen:(ESVideoPlayerControlView *)controlView withFullScreen:(BOOL)isFullScreen;
- (void)controlViewDidChangeScreen:(ESVideoPlayerControlView *)controlView;
- (void)controlView:(ESVideoPlayerControlView *)controlView switchDefinitionWithIndex:(NSUInteger)index;
- (void)controlView:(ESVideoPlayerControlView *)controlView switchRate:(float)rate;
- (void)controlViewSeek:(ESVideoPlayerControlView *)controlView where:(NSTimeInterval)pos;
- (void)controlViewPreview:(ESVideoPlayerControlView *)controlView where:(NSTimeInterval)pos;

@end
NS_ASSUME_NONNULL_END
