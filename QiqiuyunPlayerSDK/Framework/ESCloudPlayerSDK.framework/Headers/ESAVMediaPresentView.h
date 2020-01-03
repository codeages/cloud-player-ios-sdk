//
//  ESAVMediaPresentView.h
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/25.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ESAVMediaPresentView;
@interface ESAVMediaPresentControllerView : UIView
@property (nonatomic, strong, readonly, nullable) ESAVMediaPresentView *keyPresentView;
- (void)insertPresentViewToBack:(ESAVMediaPresentView *)view;
- (void)makeKeyPresentView:(ESAVMediaPresentView *)view;
- (void)removePresentView:(ESAVMediaPresentView *)view;
- (void)removeAllPresentView;

@end

@interface ESAVMediaPresentView : UIView
- (instancetype)initWithFrame:(CGRect)frame player:(nullable AVPlayer *)player;

@property (nonatomic, readonly, getter=isReadyForDisplay) BOOL readyForDisplay;
@property (nonatomic, strong, nullable) AVPlayer *player;
@property (nonatomic, copy, null_resettable) AVLayerVideoGravity videoGravity;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
