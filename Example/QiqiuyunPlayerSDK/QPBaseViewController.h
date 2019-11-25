//
//  QPBaseViewController.h
//  QiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/11/14.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ESCloudPlayerSDK/ESCloudPlayerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface QPBaseViewController : UIViewController
@property (strong, nonatomic) ESCloudPlayerView *mediaPlayerView;
@property (strong, nonatomic) NSArray<NSDictionary *> *resources;
@property (strong, nonatomic) UIButton *fullscreenButton;
@property (strong, nonatomic) UIButton *prePageButton;
@property (strong, nonatomic) UIButton *nextPageButton;

- (void)showMessage:(NSString *)message;
- (void)showMessage:(NSString *)message view:(UIView * _Nullable)view;
- (void)showProgressInView:(UIView *)view;
- (void)dissMissProgressInView:(UIView *)view;
- (void)showResourceList:(void(^)(NSDictionary *resource))callback;

- (void)addConrollItem;
- (void)fullscreenButtonClick:(UIButton *)sender;
- (void)prePage;
- (void)nextPage;

@end

NS_ASSUME_NONNULL_END
