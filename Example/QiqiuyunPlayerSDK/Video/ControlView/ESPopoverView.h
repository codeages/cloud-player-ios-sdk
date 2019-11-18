//
//  ESPopoverView.h
//  EduSoho
//
//  Created by Edusoho on 14-10-10.
//  Copyright (c) 2015年 Kuozhi Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ESPopoverAnimationType) {
    ESPopoverAnimationNone = 0,
    ESPopoverAnimationTypeLinear,
    ESPopoverAnimationTypeScale
};

@interface ESPopoverView : UIViewController

- (instancetype)initWithView:(UIView *)view titles:(NSArray *)titles images:(NSArray <UIImage *>*)images;
- (instancetype)initWithEvent:(UIEvent *)event titles:(NSArray *)titles images:(NSArray <UIImage *>*)images;
- (instancetype)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray <UIImage *>*)images;
- (void)show;
- (void)showWithAnimationType:(ESPopoverAnimationType)animationType;
- (void)dismiss:(BOOL)animated;
- (void)reloadIndex:(NSInteger)index title:(NSString *)title titleColor:(UIColor *)color;
- (void)showMaskRedBadgeIndex:(NSInteger)index;
- (void)clearMskRedBadgeIndex:(NSInteger)index;

@property (nonatomic, copy) UIColor *backColor;
@property (nonatomic, copy) UIColor *titleColor;
@property (nonatomic, copy) UIColor *selectedTitleColor;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic) CGPoint showPoint;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);

@end
