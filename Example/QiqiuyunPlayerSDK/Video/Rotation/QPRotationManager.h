//
//  QPRotationManager.h
//  QiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/11/4.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ESOrientation) {
    ESOrientation_Portrait = UIDeviceOrientationPortrait,
    ESOrientation_LandscapeLeft = UIDeviceOrientationLandscapeLeft,
    ESOrientation_LandscapeRight = UIDeviceOrientationLandscapeRight,
};

typedef enum : NSUInteger {
    ESOrientationMaskPortrait = 1 << ESOrientation_Portrait,
    ESOrientationMaskLandscapeLeft = 1 << ESOrientation_LandscapeLeft,
    ESOrientationMaskLandscapeRight = 1 << ESOrientation_LandscapeRight,
    ESOrientationMaskAll = ESOrientationMaskPortrait | ESOrientationMaskLandscapeLeft | ESOrientationMaskLandscapeRight,
} SJOrientationMask;

@protocol QPRotationManagerDelegate;
@interface QPRotationManager : NSObject

@property (nonatomic, weak, nullable) id<QPRotationManagerDelegate> delegate;

@property (nonatomic, copy, nullable) BOOL(^shouldTriggerRotation)(QPRotationManager *mgr);

///
/// 是否禁止自动旋转
/// - 该属性只会禁止自动旋转, 当调用 rotate 等方法还是可以旋转的
/// - 默认为 false
///
@property (nonatomic, getter=isDisabledAutorotation) BOOL disabledAutorotation;

///
/// 自动旋转时, 所支持的方法
/// - 默认为 .all
///
@property (nonatomic) SJOrientationMask autorotationSupportedOrientations;

///
/// 旋转
/// - Animated
///
- (void)rotate;

///
/// 旋转到指定方向
///
- (void)rotate:(ESOrientation)orientation animated:(BOOL)animated;

///
/// 旋转到指定方向
///
- (void)rotate:(ESOrientation)orientation animated:(BOOL)animated completionHandler:(nullable void(^)(QPRotationManager * mgr))completionHandler;

///
/// 当前的方向
///
@property (nonatomic, readonly) ESOrientation currentOrientation;

///
/// 是否全屏
/// - landscapeRight 或者 landscapeLeft 即为全屏
///
@property (nonatomic, readonly) BOOL isFullscreen;
@property (nonatomic, readonly, getter=isTransitioning) BOOL transitioning; // 是否正在旋转


///
/// 以下属性由播放器维护
///
@property (nonatomic, weak, nullable) UIView *superview;
@property (nonatomic, weak, nullable) UIView *target;
@property (nonatomic, copy, nullable) UIView *(^targetView)(QPRotationManager *mgr);

@property (nonatomic, copy, nullable) void(^rotationDidStartExeBlock)(QPRotationManager *mgr);
@property (nonatomic, copy, nullable) void(^rotationDidEndExeBlock)(QPRotationManager *mgr);


@end

@protocol QPRotationManagerDelegate <NSObject>
- (BOOL)vc_prefersStatusBarHidden;
- (UIStatusBarStyle)vc_preferredStatusBarStyle;
- (void)vc_forwardPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end


NS_ASSUME_NONNULL_END
