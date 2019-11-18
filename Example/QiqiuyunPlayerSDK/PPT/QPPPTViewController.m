//
//  QPPPTViewController.m
//  QiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/11/4.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "QPPPTViewController.h"

#import <QiqiuyunPlayerSDK/QiqiuyunPlayerView.h>
#import "QPJWTTokenTool.h"
#import "QPRotationManager.h"
#import <Masonry.h>

#define IPHONE_X \
({ BOOL isPhoneX = NO; \
   if (@available(iOS 11.0, *)) { \
       isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0; \
   } \
   (isPhoneX); })


#define PPT_RES_NO @"15b5916276844a918cf272c338654b28"
#define PPT_TOKEN_NO @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJubyI6IjE1YjU5MTYyNzY4NDRhOTE4Y2YyNzJjMzM4NjU0YjI4IiwianRpIjoiMDM2YzNkZGUtODRkZi00YyIsImV4cCI6MTYwNDYzNDQ1MSwidGltZXMiOjEwMDAwMDB9.BJVo8OCRflsNdPFdldrFstEsNau3FsihOWQagfpWN3o"

@interface QPPPTViewController ()<QiqiuyunPlayerProtocol>
@property (strong, nonatomic) QiqiuyunPlayerView *mediaPlayerView;
@property (strong, nonatomic) UIButton *fullscreenButton;
@property (strong, nonatomic) QPRotationManager *rotationManager;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *resNo;

@end

@implementation QPPPTViewController
- (QiqiuyunPlayerView *)mediaPlayerView {
    if (!_mediaPlayerView) {
        _mediaPlayerView = [[QiqiuyunPlayerView alloc]initWithFrame:self.view.bounds];
        _mediaPlayerView.backgroundColor = [UIColor blackColor];
        _mediaPlayerView.delegate = self;
    }
    return _mediaPlayerView;
}


- (UIButton *)fullscreenButton {
    if (!_fullscreenButton) {
        _fullscreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullscreenButton.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _fullscreenButton.layer.cornerRadius = 20;
        _fullscreenButton.clipsToBounds = YES;
        _fullscreenButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_fullscreenButton setImage:[UIImage imageNamed:@"VideoFullscreenIcon"] forState:UIControlStateNormal];
        [_fullscreenButton setImage:[UIImage imageNamed:@"ShrinkScreenIcon"] forState:UIControlStateSelected];
        [_fullscreenButton addTarget:self action:@selector(fullscreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullscreenButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.containerView addSubview:self.mediaPlayerView];
    
    [self.mediaPlayerView addSubview:self.fullscreenButton];
    [self.mediaPlayerView bringSubviewToFront:self.fullscreenButton];
    [self.fullscreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-15);
        make.right.mas_equalTo(-10);
    }];
    
    [self showProgressInView:self.view];
    __weak typeof(self) _self = self;
    [self.mediaPlayerView loadResourceWithToken:PPT_TOKEN_NO resNo:PPT_RES_NO completionHandler:^(NSDictionary * _Nullable resource, NSError * _Nullable error) {
        __strong typeof(_self) self = _self;
        [self dissMissProgressInView:self.view];

    }];
    
    QPRotationManager *rotationManager = [[QPRotationManager alloc] init];
    rotationManager.delegate = (id)self;
    _rotationManager = rotationManager;
    [self _setupRotationManager:_rotationManager];

}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (!_rotationManager.isFullscreen) {
        self.mediaPlayerView.frame = self.containerView.bounds;
    }
}

#pragma mark - private M
- (void)_setupRotationManager:(QPRotationManager *)rotationManager {
    if ( !rotationManager )
        return;
    rotationManager.superview = self.containerView;
    rotationManager.target = self.mediaPlayerView;
    __weak typeof(self) _self = self;
    rotationManager.shouldTriggerRotation = ^BOOL(QPRotationManager *_Nonnull mgr) {
//        __strong typeof(_self) self = _self;
        return YES;
    };
    
    rotationManager.rotationDidStartExeBlock = ^(QPRotationManager * _Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;

        [UIView animateWithDuration:0.0f animations:^{
        } completion:^(BOOL finished) {
            if ( mgr.isFullscreen )
                [self needHiddenStatusBar];
            else
                [self needShowStatusBar];
        }];
    };
    
    rotationManager.targetView = ^UIView * _Nonnull(QPRotationManager * _Nonnull mgr) {
        __strong typeof(_self) self = _self;
        return self.mediaPlayerView;
    };
    
    
    rotationManager.rotationDidEndExeBlock = ^(QPRotationManager  *_Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        if ( mgr.isFullscreen ) {
            self.fullscreenButton.selected = YES;
            [self needShowStatusBar];
        }else {
            [UIView animateWithDuration:0.25 animations:^{
                self.fullscreenButton.selected = NO;
                [self needHiddenStatusBar];
            }];
        }
    };
}

- (void)needShowStatusBar {
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)needHiddenStatusBar {
    [self setNeedsStatusBarAppearanceUpdate];
}


- (void)fullscreenButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.rotationManager rotate];
}

- (IBAction)prePage:(id)sender {
    [self.mediaPlayerView.pptPlayerContoller  previousPage];
}
- (IBAction)nextPage:(id)sender {
    [self.mediaPlayerView.pptPlayerContoller  nextPage];
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
    if ( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() ) {
        // 如果self不支持旋转, 返回仅支持竖屏
        if ( self.shouldAutorotate == NO )
            return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


#pragma mark - QPRotationManagerDelegate
- (BOOL)vc_prefersStatusBarHidden {
    if ( self.rotationManager.isTransitioning )
        return NO;
    
    // 全屏播放时, 使状态栏根据控制层显示或隐藏
    if ( self.rotationManager.isFullscreen )
        return YES;
    
    return NO;
}
- (UIStatusBarStyle)vc_preferredStatusBarStyle {
    if ( self.rotationManager.isTransitioning)
        return UIStatusBarStyleLightContent;
        
    // 全屏播放时, 使状态栏变成白色
    if ( self.rotationManager.isFullscreen) return UIStatusBarStyleLightContent;
    return UIStatusBarStyleDefault;
}

- (void)vc_forwardPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UINavigationController *nav = self.navigationController;
    if ( nav ) {
        [self.rotationManager rotate:ESOrientation_Portrait animated:YES completionHandler:^(QPRotationManager * _Nonnull mgr) {
            [nav pushViewController:viewController animated:animated];
        }];
    }
}

- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView pptScrollPageAtIndex:(NSInteger)index{
    
}

- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView pptTapPageAtIndex:(NSInteger)index{
    
}


@end
