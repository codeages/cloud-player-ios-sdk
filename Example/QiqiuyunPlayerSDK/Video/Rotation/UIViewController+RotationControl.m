//
//  UIViewController+RotationControl.m
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/30.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "UIViewController+RotationControl.h"

@implementation UIViewController (RotationControl)
/////
///// 控制器是否可以旋转
/////
//- (BOOL)shouldAutorotate {
//    if ( [self isKindOfClass:NSClassFromString(@"ESVideoViewController")] ) {
//        // 返回 NO, 不允许控制器旋转
//        return NO;
//    }
//    
//    // 返回 YES, 允许控制器旋转
//    return YES;
//}
//
/////
///// 控制器旋转支持的方向
/////
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    // 此处为设置 iPhone 某个控制器旋转支持的方向
//    // - 请根据实际情况进行修改.
//    if ( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() ) {
//        // 如果self不支持旋转, 返回仅支持竖屏
//        if ( self.shouldAutorotate == NO )
//            return UIInterfaceOrientationMaskPortrait;
//    }
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}

@end
