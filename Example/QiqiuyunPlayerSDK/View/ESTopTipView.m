//
//  ESTopTipView.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/11.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESTopTipView.h"

@implementation ESTopTipView
+ (instancetype)createTopTipViewWithTipText:(NSString *)tipText{
  ESTopTipView *view = [[[NSBundle mainBundle]loadNibNamed:@"ESTopTipView" owner:nil options:nil]lastObject];
    view.tipLabel.text = tipText;
    return view;
}
- (IBAction)rightButtonClick:(UIButton *)sender {
    if (self.rightButtonClick) {
        self.rightButtonClick();
    }
}
@end
