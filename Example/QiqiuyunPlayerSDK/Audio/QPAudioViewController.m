//
//  ESAudioViewController.m
//  ESMediaPlayerSDK_Example
//
//  Created by aaayi on 2019/10/31.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "QPAudioViewController.h"

#import <QiqiuyunPlayerSDK/QiqiuyunPlayerView.h>
#import "ESAudioPlayerCoverView.h"
#import "QPJWTTokenTool.h"
#import <Masonry.h>

#define IPHONE_X \
({ BOOL isPhoneX = NO; \
   if (@available(iOS 11.0, *)) { \
       isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0; \
   } \
   (isPhoneX); })

#define AUDIO_RES_NO @"f04e4d849c334ec1a43f650be1bc18c8"
#define AUDIO_TOKEN @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJubyI6ImYwNGU0ZDg0OWMzMzRlYzFhNDNmNjUwYmUxYmMxOGM4IiwianRpIjoiMDMwZWM5YzUtNDg3Zi00OSIsImV4cCI6MTYwNDYzNDQ1MiwidGltZXMiOjEwMDAwMDB9.txpvYNcbFaW2HcGpFyRvYo5ze_zft2vg44wsedRu8ho"

@interface QPAudioViewController ()<QiqiuyunPlayerProtocol>
@property (strong, nonatomic) QiqiuyunPlayerView *mediaPlayerView;
@property (strong, nonatomic) ESAudioPlayerCoverView *audioCoverView;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *resNo;

@end

@implementation QPAudioViewController
- (QiqiuyunPlayerView *)mediaPlayerView {
    if (!_mediaPlayerView) {
        _mediaPlayerView = [[QiqiuyunPlayerView alloc]initWithFrame:self.view.bounds];
        _mediaPlayerView.backgroundColor = [UIColor blackColor];
        _mediaPlayerView.delegate = self;
    }
    return _mediaPlayerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mediaPlayerView];
    [self.mediaPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(20 + self.navigationController.navigationBar.bounds.size.height);
        }
        make.leading.trailing.mas_equalTo(0);
        // 这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(self.mediaPlayerView.mas_width).multipliedBy(9.0f / 16.0f);
    }];
    
    self.token = [QPJWTTokenTool JWTTokenWithResNo:AUDIO_RES_NO];
    self.resNo = AUDIO_RES_NO;
    
    _audioCoverView = [ESAudioPlayerCoverView createdAudioPlayerCoverView];
    _audioCoverView.coverImageUrl = @"https://pics2.baidu.com/feed/730e0cf3d7ca7bcbe4d2f6d31d0bc666f724a8ad.jpeg?token=f15c9288e3a5dc6f9e8209cb7fa83b75&s=8909B3551720C945060D6DEA0300A022";
    _audioCoverView.frame = _mediaPlayerView.bounds;
    [self.mediaPlayerView addSubview:_audioCoverView];

    [self showProgressInView:self.view];
    __weak typeof(self) _self = self;
    [self.mediaPlayerView loadResourceWithToken:self.token resNo:self.resNo completionHandler:^(NSDictionary * _Nullable resource, NSError * _Nullable error) {
        __strong typeof(_self) self = _self;
        [self dissMissProgressInView:self.view];

    }];
}

- (void)mediaPlayerOnPause:(QiqiuyunPlayerView *)playerView{
    [_audioCoverView stopRotating];
}

- (void)mediaPlayerOnStop:(QiqiuyunPlayerView *)playerView reason:(QiqiuyunPlayerStopReason)reason{
    [_audioCoverView stopRotating];
}

- (void)mediaPlayerOnResume:(QiqiuyunPlayerView *)playerView{
    [_audioCoverView startRotating];

}

- (IBAction)resumePlay:(id)sender {
    [self.mediaPlayerView.videoPlayerContoller play];
}

- (IBAction)pausePlay:(id)sender {
    [self.mediaPlayerView.videoPlayerContoller pause];

}

- (IBAction)stopPlay:(id)sender {
    [self.mediaPlayerView.videoPlayerContoller stop];
}
@end
