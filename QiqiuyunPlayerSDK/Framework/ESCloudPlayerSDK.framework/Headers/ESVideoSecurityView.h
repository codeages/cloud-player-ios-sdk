//
//  ESVideoSecurityView.h
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/25.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCloudPlayerDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESVideoSecurityView : UIView
@property (strong, nonatomic) UILabel *subtitleLabel;
- (void)showFingerprint:(NSString *)fpText fadeTime:(NSTimeInterval)fTime;
- (void)showWatermarkWithImageURL:(NSURL * _Nullable)imageURL position:(ESCloudPlayerWatermarkPosition)position;

@end

NS_ASSUME_NONNULL_END
