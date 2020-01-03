//
//  ESBasePlayViewController.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/11.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESBaseViewController.h"
#import "ESRotationManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface ESBasePlayViewController : ESBaseViewController
- (instancetype)initWithBaseURL:(NSURL *)baseURL;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) ESCloudPlayerView *mediaPlayerView;
@property (strong, nonatomic) UIButton *fullscreenButton;
@property (strong, nonatomic) UIButton *prePageButton;
@property (strong, nonatomic) UIButton *nextPageButton;

- (void)addConrollItem;
- (void)fullscreenButtonClick:(UIButton *)sender;
- (void)prePage;
- (void)nextPage;

@end

NS_ASSUME_NONNULL_END
