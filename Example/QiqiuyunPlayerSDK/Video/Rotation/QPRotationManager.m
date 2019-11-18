//
//  QPRotationManager.m
//  QiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/11/4.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "QPRotationManager.h"


@class QPFullscreenModeViewController, ESFullscreenModeNavigationController;

NS_ASSUME_NONNULL_BEGIN
@protocol QPFullscreenModeViewControllerDelegate <NSObject>
- (UIView *)target;
- (CGRect)targetOriginFrame;
- (BOOL)prefersStatusBarHidden;
- (UIStatusBarStyle)preferredStatusBarStyle;

- (BOOL)shouldAutorotateToOrientation:(UIDeviceOrientation)orientation;
- (void)fullscreenModeViewController:(QPFullscreenModeViewController *)vc willRotateToOrientation:(UIDeviceOrientation)orientation;
- (void)fullscreenModeViewController:(QPFullscreenModeViewController *)vc didRotateFromOrientation:(UIDeviceOrientation)orientation;
@end

@interface QPFullscreenModeViewController : UIViewController
@property (nonatomic, weak, nullable) id<QPFullscreenModeViewControllerDelegate> delegate;
@property (nonatomic) UIDeviceOrientation currentOrientation;
@property (nonatomic, readonly) BOOL isFullscreen;
@property (nonatomic) BOOL isRotated;
@end

@implementation QPFullscreenModeViewController
- (instancetype)init {
    self = [super init];
    if ( self ) {
        _currentOrientation = UIDeviceOrientationPortrait;
    }
    return self;
}

- (BOOL)shouldAutorotate {
    return [self.delegate shouldAutorotateToOrientation:UIDevice.currentDevice.orientation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ( self.presentedViewController != nil )
        return 1 << _currentOrientation;
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    UIDeviceOrientation new = UIDevice.currentDevice.orientation;
    UIDeviceOrientation old = _currentOrientation;
    
    if ( new == UIDeviceOrientationLandscapeLeft ||
         new == UIDeviceOrientationLandscapeRight ) {
        if ( self.delegate.target.superview != self.view ) {
            [self.view addSubview:self.delegate.target];
        }
    }
    
    if ( old == UIDeviceOrientationPortrait ) {
        self.delegate.target.frame = self.delegate.targetOriginFrame;
    }
    
    _currentOrientation = new;

    [self.delegate fullscreenModeViewController:self willRotateToOrientation:_currentOrientation];
    
    BOOL isFullscreen = size.width > size.height;
    [UIView animateWithDuration:0.3 animations:^{
        if ( isFullscreen ){
            self.delegate.target.frame = CGRectMake(0, 0, size.width, size.height);
        }else{
//            self.delegate.target.frame = self.delegate.targetOriginFrame;
            CGRect frame = self.delegate.targetOriginFrame;
            frame.origin = CGPointMake(0, 0);
            self.delegate.target.frame = frame;
        }
        
//        NSLog(@"/n/nsize -(%f, %f), ( %f, %f )/n/n",  self.delegate.target.frame.origin.x, self.delegate.target.frame.origin.y, self.delegate.target.frame.size.width,  self.delegate.target.frame.size.height);
        [self.delegate.target.superview layoutIfNeeded];
        [self.delegate.target layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate fullscreenModeViewController:self didRotateFromOrientation:self.currentOrientation];
        });
    }];
}

- (BOOL)isFullscreen {
    return _currentOrientation == UIDeviceOrientationLandscapeLeft || _currentOrientation == UIDeviceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden {
    return self.delegate.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.delegate.preferredStatusBarStyle;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (void)setNeedsStatusBarAppearanceUpdate {
    [super setNeedsStatusBarAppearanceUpdate];
}
@end


@protocol QPFullscreenModeNavigationControllerDelegate <NSObject>
- (void)vc_forwardPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end

@interface ESFullscreenModeNavigationController : UINavigationController
@property (nonatomic, weak, nullable) id<QPFullscreenModeNavigationControllerDelegate> ES_delegate;
@end

@implementation ESFullscreenModeNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [super setNavigationBarHidden:YES];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [super setNavigationBarHidden:YES animated:animated];
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}
- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}
- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ( [viewController isKindOfClass:QPFullscreenModeViewController.class] ) {
        [super pushViewController:viewController animated:animated];
    }
    else if ( [self.ES_delegate respondsToSelector:@selector(vc_forwardPushViewController:animated:)] ) {
        [self.ES_delegate vc_forwardPushViewController:viewController animated:animated];
    }
}
@end

#pragma mark -

@interface QPFullscreenModeWindow : UIWindow
@property (nonatomic, strong, nullable) ESFullscreenModeNavigationController *rootViewController;
@property (nonatomic, strong, readonly) QPFullscreenModeViewController *fullscreenModeViewController;
@end

@implementation QPFullscreenModeWindow
@dynamic rootViewController;

#ifdef DEBUG
- (void)dealloc {
    NSLog(@"%d \t %s", (int)__LINE__, __func__);
}
#endif

- (void)setBackgroundColor:(nullable UIColor *)backgroundColor {}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( !self ) return nil;
    self.windowLevel = UIWindowLevelNormal;
    _fullscreenModeViewController = QPFullscreenModeViewController.new;
    self.rootViewController = [[ESFullscreenModeNavigationController alloc] initWithRootViewController:_fullscreenModeViewController];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if ( @available(iOS 13.0, *) ) {
        if ( self.windowScene == nil )
            self.windowScene = UIApplication.sharedApplication.keyWindow.windowScene;
    }
#endif
    self.hidden = YES;
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *_Nullable)event {
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    static CGRect bounds;
    
    // 如果是大屏转大屏 就不需要修改了
    
    if ( !CGRectEqualToRect(bounds, self.bounds) ) {
        
        UIView *superview = self;
        if ( @available(iOS 13.0, *) ) {
            superview = self.subviews.firstObject;
        }

        [UIView performWithoutAnimation:^{
            for ( UIView *view in superview.subviews ) {
                if ( view != self.rootViewController.view && [view isMemberOfClass:UIView.class] ) {
                    view.backgroundColor = UIColor.clearColor;
                    for ( UIView *subview in view.subviews ) {
                        subview.backgroundColor = UIColor.clearColor;
                    }
                }
                
            }
        }];
    }
    
    bounds = self.bounds;
    self.rootViewController.view.frame = bounds;
}
@end



static NSNotificationName const QPRotationManagerTransitioningValueDidChangeNotification = @"QPRotationManagerTransitioningValueDidChangeNotification";


@interface QPRotationManager ()<QPFullscreenModeViewControllerDelegate, QPFullscreenModeNavigationControllerDelegate>
@property (nonatomic, strong) QPFullscreenModeWindow *window;
@property (nonatomic, weak, nullable) UIWindow *previousKeyWindow;

@property (nonatomic) UIDeviceOrientation deviceOrientation;
@property (nonatomic) BOOL forcedRotation;
@property (nonatomic, getter=isTransitioning) BOOL transitioning;
@property (nonatomic) ESOrientation currentOrientation;
@end

@implementation QPRotationManager {
    void(^_Nullable _completionHandler)(QPRotationManager *mgr);
}

@synthesize autorotationSupportedOrientations = _autorotationSupportedOrientations;
@synthesize shouldTriggerRotation = _shouldTriggerRotation;
@synthesize disabledAutorotation = _disabledAutorotation;
@synthesize superview = _superview;
@synthesize target = _target;

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentOrientation = ESOrientation_Portrait;
        _autorotationSupportedOrientations = ESOrientationMaskAll;
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_window = [QPFullscreenModeWindow new];
            self->_window.fullscreenModeViewController.delegate = self;
            self->_window.rootViewController.ES_delegate = self;
            if ( @available(iOS 9.0, *) ) {
                [self->_window.rootViewController loadViewIfNeeded];
            }
            else {
                [self->_window.rootViewController view];
            }
        });
        [self _observeDeviceOrientationChangeNotification];
    }
    return self;
}

- (void)_observeDeviceOrientationChangeNotification {
    UIDevice *device = UIDevice.currentDevice;
    if ( !device.isGeneratingDeviceOrientationNotifications ) {
        [device beginGeneratingDeviceOrientationNotifications];
    }
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:device];
}

- (void)deviceOrientationDidChange:(NSNotification *)note {
    UIDeviceOrientation orientation = UIDevice.currentDevice.orientation;
    switch ( orientation ) {
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight: {
            _deviceOrientation = orientation;
        }
            break;
        default: break;
    }
}

#pragma mark -

- (BOOL)isFullscreen {
    return _currentOrientation == (NSInteger)UIDeviceOrientationLandscapeLeft ||
           _currentOrientation == (NSInteger)UIDeviceOrientationLandscapeRight;
}

- (void)rotate {
    if ( ![self _isSupported:ESOrientation_LandscapeLeft] &&
         ![self _isSupported:ESOrientation_LandscapeRight] ) {
        if ( self.isFullscreen )
            [self rotate:ESOrientation_Portrait animated:YES];
        else
            [self rotate:ESOrientation_LandscapeLeft animated:YES];
        return;
    }
    
    if ( self.isFullscreen && [self _isSupported:ESOrientation_Portrait] ) {
        [self rotate:ESOrientation_Portrait animated:YES];
        return;
    }
    
    
    if ( [self _isSupported:ESOrientation_LandscapeLeft] &&
         [self _isSupported:ESOrientation_LandscapeRight] ) {
        ESOrientation orientation = (NSInteger)_deviceOrientation;
        if ( self.window.fullscreenModeViewController.currentOrientation == ESOrientation_Portrait )
            orientation = ESOrientation_LandscapeLeft;
        [self rotate:orientation animated:YES];
        return;
    }
    
    if ( [self _isSupported:ESOrientation_LandscapeLeft] &&
        ![self _isSupported:ESOrientation_LandscapeRight] ) {
        [self rotate:ESOrientation_LandscapeLeft animated:YES];
        return;
    }
    
    if ( ![self _isSupported:ESOrientation_LandscapeLeft] &&
          [self _isSupported:ESOrientation_LandscapeRight] ) {
        [self rotate:ESOrientation_LandscapeRight animated:YES];
        return;
    }
}

- (void)rotate:(ESOrientation)orientation animated:(BOOL)animated {
    [self rotate:orientation animated:animated completionHandler:nil];
}

- (void)rotate:(ESOrientation)orientation animated:(BOOL)animated completionHandler:(nullable void(^)(QPRotationManager *mgr))completionHandler {
    _completionHandler = completionHandler;
    if ( orientation == (NSInteger)self.window.fullscreenModeViewController.currentOrientation ) {
        [self _finishTransition];
        return;
    }
    
    _forcedRotation = YES;
    [UIDevice.currentDevice setValue:@(UIDeviceOrientationUnknown) forKey:@"orientation"];
    [UIDevice.currentDevice setValue:@(orientation) forKey:@"orientation"];
    _forcedRotation = NO;
}

- (UIView *_Nullable)target{
    if (!_target) {
        if (self.targetView) {
           _target = self.targetView(self);
        }
    }
    return _target;
}

#pragma mark -

- (CGRect)targetOriginFrame {
    if ( self.superview.window == nil )
        return CGRectZero;
    CGRect rect = [self.superview convertRect:self.superview.bounds toView:self.superview.window];
//    NSLog(@"/n/targetOriginFrame -(%f, %f) ( %f, %f )/n/n", rect.origin.x, rect.origin.x, rect.size.width, rect.size.height);
    return rect;
}

- (BOOL)prefersStatusBarHidden {
    return self.delegate.vc_prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.delegate.vc_preferredStatusBarStyle;
}

- (void)vc_forwardPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ( [self.delegate respondsToSelector:@selector(vc_forwardPushViewController:animated:)] ) {
        [self.delegate vc_forwardPushViewController:viewController animated:animated];
    }
}

#pragma mark -

- (BOOL)shouldAutorotateToOrientation:(UIDeviceOrientation)orientation {
    if ( orientation == (NSInteger)_window.fullscreenModeViewController.currentOrientation )
        return NO;
    
    if ( self.isDisabledAutorotation && !_forcedRotation )
        return NO;
    
    if ( self.isTransitioning && _window.fullscreenModeViewController.isRotated )
        return NO;
    
    if ( !_forcedRotation ) {
        if ( ![self _isSupported:(NSInteger)orientation] )
            return NO;
    }
    
    if ( _shouldTriggerRotation && !_shouldTriggerRotation(self) )
        return NO;
    
    self.currentOrientation = (NSInteger)orientation;
    
    if ( self.isTransitioning == NO )
        [self _beginTransition];
    
    if ( orientation == UIDeviceOrientationLandscapeLeft ||
         orientation == UIDeviceOrientationLandscapeRight ) {
        UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
        if ( keyWindow != self.window && self.previousKeyWindow != keyWindow ) {
            self.previousKeyWindow = UIApplication.sharedApplication.keyWindow;
        }
        if ( self.window.isKeyWindow == NO )
            [self.window makeKeyAndVisible];
    }
    return YES;
}

- (void)fullscreenModeViewController:(QPFullscreenModeViewController *)vc willRotateToOrientation:(UIDeviceOrientation)orientation { }

- (void)fullscreenModeViewController:(QPFullscreenModeViewController *)vc didRotateFromOrientation:(UIDeviceOrientation)orientation {
    if ( !vc.isFullscreen ) {
        UIView *snapshot = [self.target snapshotViewAfterScreenUpdates:NO];
        snapshot.frame = self.superview.bounds;
        [self.superview addSubview:snapshot];
//        ESRunLoopTaskQueue.main.enqueue(^{
//        }).enqueue(^{
            [self.superview addSubview:self.target];
            [snapshot removeFromSuperview];
            UIWindow *previousKeyWindow = self.previousKeyWindow?:UIApplication.sharedApplication.windows.firstObject;
            [previousKeyWindow makeKeyAndVisible];
            self.previousKeyWindow = nil;
            self.window.hidden = YES;
//            [self.superview layoutIfNeeded];
//            [self.superview setNeedsLayout];
//            [self.target layoutIfNeeded];
            [self _finishTransition];
//        });
    }
    else {
        [self _finishTransition];
    }
    
}

- (void)_beginTransition {
    self.transitioning = YES;
    self.window.fullscreenModeViewController.isRotated = NO;
    
#ifdef DEBUG
    NSLog(@"%d \t %s", (int)__LINE__, __func__);
#endif
}

- (void)_finishTransition {
    self.window.fullscreenModeViewController.isRotated = YES;
    self.transitioning = NO;
    
    if ( _completionHandler )
        _completionHandler(self);
    
    _completionHandler = nil;

#ifdef DEBUG
    NSLog(@"%d \t %s", (int)__LINE__, __func__);
#endif
}

- (BOOL)_isSupported:(ESOrientation)orientation {
    switch ( orientation ) {
        case ESOrientation_Portrait:
            return _autorotationSupportedOrientations & ESOrientationMaskPortrait;
        case ESOrientation_LandscapeLeft:
            return _autorotationSupportedOrientations & ESOrientationMaskLandscapeLeft;
        case ESOrientation_LandscapeRight:
            return _autorotationSupportedOrientations & ESOrientationMaskLandscapeRight;
    }
    return NO;
}

#pragma mark -
- (void)setTransitioning:(BOOL)transitioning {
    _transitioning = transitioning;
    if ( transitioning ) {
        if ( _rotationDidStartExeBlock )
            _rotationDidStartExeBlock(self);
    }
    else {
        if ( _rotationDidEndExeBlock )
            _rotationDidEndExeBlock(self);
    }
}
@end

NS_ASSUME_NONNULL_END
