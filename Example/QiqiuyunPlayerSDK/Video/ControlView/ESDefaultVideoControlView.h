//
//  ESDefaultVideoControlView.h
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/30.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "ESVideoPlayerControlView.h"

NS_ASSUME_NONNULL_BEGIN

@class ESVideoPlayerSlider;
@interface ESDefaultVideoControlView : ESVideoPlayerControlView
@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;
//子类重新
- (BOOL)showFullScreen;
@end

NS_ASSUME_NONNULL_END
