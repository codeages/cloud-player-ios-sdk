//
//  ESTopTipView.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/11.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESTopTipView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (copy, nonatomic) void(^rightButtonClick)();
+ (instancetype)createTopTipViewWithTipText:(NSString *)tipText;

@end

NS_ASSUME_NONNULL_END
