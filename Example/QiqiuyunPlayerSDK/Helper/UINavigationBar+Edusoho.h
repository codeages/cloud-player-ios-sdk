//
//  UINavigationBar+Edusoho.h
//  SaiYou
//
//  Created by ayia on 2019/1/14.
//  Copyright © 2019年 ayia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (Edusoho)
- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setElementsAlpha:(CGFloat)alpha;
- (void)lt_setTranslationY:(CGFloat)translationY;
- (void)lt_reset;

@end

NS_ASSUME_NONNULL_END
