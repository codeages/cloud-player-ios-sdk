//
//  ESBaseViewController.h
//  ESMediaPlayerSDK_Example
//
//  Created by aaayi on 2019/11/13.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESBaseViewController : UIViewController
@property (copy, nonatomic) NSString *resNo;
@property (copy, nonatomic) NSString *token;

@property (strong, nonatomic) NSArray<NSDictionary *> *resources;
- (void)goBack;
- (void)showError:(NSError *)error view:(UIView *)view;
- (void)showSuccess:(NSString *)message view:(UIView *)view;
- (void)showMessage:(NSString *)message;
- (void)showMessage:(NSString *)message view:(UIView * _Nullable)view;
- (void)showProgressInView:(UIView *)view;
- (void)dissMissProgressInView:(UIView *)view;
- (void)showResourceList:(void(^)(NSDictionary *resource))callback;

@end

NS_ASSUME_NONNULL_END
