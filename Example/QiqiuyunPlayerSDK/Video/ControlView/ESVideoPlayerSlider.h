//
//  ESVideoPlayerSlider.h
//  ESMediaPlayerSDK_Example
//
//  Created by aaayi on 2019/10/30.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESVideoPlayerSlider : QMUISlider
@property UIProgressView *progressView;
@property (nonatomic) BOOL hiddenPoints;
@end

NS_ASSUME_NONNULL_END
