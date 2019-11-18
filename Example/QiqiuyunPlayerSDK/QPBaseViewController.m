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
@interface QPBaseViewController ()

@end

@implementation QPBaseViewController
- (UIView*)getView:(UIView *)view {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

