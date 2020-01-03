//
//  PKCircleView+Edusoho.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/17.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "PKCircleView+Edusoho.h"

@implementation PKCircleProgressView (Edusoho)
- (void)setCircleColor:(UIColor *)circleColor {
    [self setValue:circleColor forKeyPath:@"filledLineCircleView.tintColor"];
    [self setValue:[UIColor clearColor] forKeyPath:@"emptyLineCircleView.tintColor"];
    [self setNeedsDisplay];
}

@end

@implementation PKCircleView (Edusoho)
- (void)setCircleColor:(UIColor *)circleColor {
    self.tintColor = circleColor;
    [self setNeedsDisplay];
}

@end
