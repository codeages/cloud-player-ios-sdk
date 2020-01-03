//
//  ESPlayerView.h
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/22.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ESPlayerViewDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface ESPlayerView : UIView
@property (nonatomic, weak, nullable) id<ESPlayerViewDelegate> delegate;

@end

@protocol ESPlayerViewDelegate <NSObject>
- (void)playerViewDidLayoutSubviews:(ESPlayerView *)playerView;
- (void)playerViewWillMoveToWindow:(ESPlayerView *)playerView;
- (nullable UIView *)playerView:(ESPlayerView *)playerView hitTestForView:(nullable __kindof UIView *)view;
@end

NS_ASSUME_NONNULL_END
