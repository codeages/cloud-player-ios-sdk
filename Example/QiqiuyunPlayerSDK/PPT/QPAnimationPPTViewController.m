//
//  QPAnimationPPTViewController.m
//  QiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/11/19.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "QPAnimationPPTViewController.h"
#import <ESCloudPlayerSDK/ESCloudPlayerView.h>
#import "QPJWTTokenTool.h"
#import "QPRotationManager.h"
#import <Masonry.h>

#define PPT_RES_NO @"3b8be26eb03a4df3bd95847c9e3645e7"

@interface QPAnimationPPTViewController ()
@property (strong, nonatomic) QPRotationManager *rotationManager;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation QPAnimationPPTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.containerView addSubview:self.mediaPlayerView];
        
    NSString *token = [QPJWTTokenTool JWTTokenWithPlayload:PPT_RES_NO previewTime:0 headResNo:@"" isPlayAudio:YES];
    [self showProgressInView:self.view];
    __weak typeof(self) _self = self;
    [self.mediaPlayerView loadResourceWithToken:token resNo:PPT_RES_NO specifyStartPos:3 completionHandler:^(NSDictionary * _Nullable resource, NSError * _Nullable error) {
        __strong typeof(_self) self = _self;
        [self dissMissProgressInView:self.view];
        if (error) {
            [self showMessage:error.userInfo[@"message"] view:nil];
        } else {
            NSLog(@"%@", resource);
        }
    }];
    
    QPRotationManager *rotationManager = [[QPRotationManager alloc] init];
    rotationManager.delegate = (id)self;
    _rotationManager = rotationManager;
    [self _setupRotationManager:_rotationManager];
    
    [self addConrollItem];

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

- (void)prePage {
    [self.mediaPlayerView.docPlayerContoller  previousPage];
}
- (void)nextPage {
    [self.mediaPlayerView.docPlayerContoller  nextPage];
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

- (void)mediaPlayer:(ESCloudPlayerView *)playerView documentOnPrepared:(NSDictionary *)data{
    [self showMessage:@"加载完成"];
}

- (void)mediaPlayerDocumentOnEnd:(ESCloudPlayerView *)playerView{
    [self showMessage:@"已经到底了"];
}

- (void)mediaPlayer:(ESCloudPlayerView *)playerView documentPagechanged:(NSInteger)index{
    self.title = [NSString stringWithFormat:@"%ld/%ld", (long)index, (long)playerView.docPlayerContoller.pageCount];
}

- (void)mediaPlayerDocumentOnFullscreen:(ESCloudPlayerView *)playerView{
    
}

@end
