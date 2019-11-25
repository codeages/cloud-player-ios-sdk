//
//  QPBaseViewController.m
//  QiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/11/14.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "QPBaseViewController.h"

#import <JGProgressHUD/JGProgressHUD.h>
#import <QMUIKit/QMUIAlertController.h>
#import <Masonry.h>

#define IPHONE_X \
({ BOOL isPhoneX = NO; \
   if (@available(iOS 11.0, *)) { \
       isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0; \
   } \
   (isPhoneX); })

@interface QPBaseViewController ()<ESCloudPlayerProtocol>

@end

@implementation QPBaseViewController
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

- (UIButton *)nextPageButton {
    if (!_nextPageButton) {
        _nextPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextPageButton.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _nextPageButton.layer.cornerRadius = 5;
        _nextPageButton.clipsToBounds = YES;
        _nextPageButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_nextPageButton setTitle:@"下一页"  forState:UIControlStateNormal];
        [_nextPageButton addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextPageButton;
}

- (UIButton *)prePageButton {
    if (!_prePageButton) {
        _prePageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _prePageButton.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _prePageButton.layer.cornerRadius = 5;
        _prePageButton.clipsToBounds = YES;
        _prePageButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_prePageButton setTitle:@"上一页"  forState:UIControlStateNormal];
        [_prePageButton addTarget:self action:@selector(prePage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _prePageButton;
}

- (ESCloudPlayerView *)mediaPlayerView {
    if (!_mediaPlayerView) {
        _mediaPlayerView = [[ESCloudPlayerView alloc]initWithFrame:CGRectZero];
        _mediaPlayerView.backgroundColor = [UIColor blackColor];
        _mediaPlayerView.delegate = self;
    }
    return _mediaPlayerView;
}

- (UIView*)getView:(UIView *)view {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)addConrollItem{
    [self.mediaPlayerView addSubview:self.fullscreenButton];
    [self.fullscreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-15);
        make.right.mas_equalTo(-10);
    }];
    
    [self.mediaPlayerView addSubview:self.prePageButton];
    [self.prePageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fullscreenButton);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        make.left.mas_equalTo(self.mediaPlayerView.mas_left).offset(20);
    }];

    [self.mediaPlayerView addSubview:self.nextPageButton];
    [self.nextPageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fullscreenButton);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        make.left.mas_equalTo(self.prePageButton.mas_right).offset(20);
    }];
}
- (void)fullscreenButtonClick:(UIButton *)sender {
}

- (void)prePage {

}
- (void)nextPage {
}


- (void)showMessage:(NSString *)message{
    [self showMessage:message view:self.view];
}

- (void)showMessage:(NSString *)message view:(UIView *)view{
    JGProgressHUD *HUD = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleExtraLight];
    HUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    HUD.indicatorView = nil;
    HUD.textLabel.text = message;
    HUD.position = JGProgressHUDPositionBottomCenter;
    HUD.marginInsets = (UIEdgeInsets) {
        .top = 0.0f,
        .bottom = 55.0f,
        .left = 0.0f,
        .right = 0.0f,
    };
    HUD.contentInsets = (UIEdgeInsets){
        .top = 5,
        .bottom = 5,
        .left = 5,
        .right = 5,
    };
    [HUD showInView:[self getView:view]];
    [HUD dismissAfterDelay:1.0];
}

- (void)showProgressInView:(UIView *)view title:(NSString *)title message:(NSString *)message {
    
    
    if ([self existingProgressHUDsInView:view]) {
        return;
    }

    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = title;
    HUD.detailTextLabel.text = message?:@"加载中...";
    [HUD showInView:[self getView:view]];
}

- (void)showProgressInView:(UIView *)view{
    [self showProgressInView:view title:nil message:nil];
}
/**
 *  是否存在正在显示的HUD
 *
 *  @param view view
 *
 */
- (BOOL)existingProgressHUDsInView:(UIView *)view{
    NSArray *huds = [JGProgressHUD allProgressHUDsInView:view];
    if (huds.count>0) {//该view上已经存在hud 不再添加
        return YES;
    }
    
    view = [UIApplication sharedApplication].keyWindow;
    huds = [JGProgressHUD allProgressHUDsInView:view];
    if (huds.count>0) {//该keyWindow上已经存在hud 不再添加
        return YES;
    }
    return NO;
}


- (void)dissMissProgressInView:(UIView *)view animation:(BOOL)animation {
    view = [self getView:view];
    
    NSArray *huds = [JGProgressHUD allProgressHUDsInView:view];
    for (JGProgressHUD *HUD in huds) {
        [HUD dismissAnimated:animation];
    }
}

- (void)dissMissProgressInView:(UIView *)view {
    [self  dissMissProgressInView:[self getView:view] animation:YES];
}

- (void)showResourceList:(void(^)(NSDictionary *resource))callback{
    QMUIAlertController *aVC = [[QMUIAlertController alloc]initWithTitle:@"请选择资源" message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [self.resources enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:obj[@"message"]?:@"" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            if (callback) {
                callback(obj);
            }
        }];
        [aVC addAction:action];
    }];
    QMUIAlertAction *cAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
    }];
    [aVC addAction:cAction];
    [aVC showWithAnimated:YES];
}
@end

