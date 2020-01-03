//
//  ESPPTView.h
//  EduSoho
//
//  Created by LiweiWang on 2016/12/20.
//  Copyright © 2016年 Kuozhi Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ESPPTView;
@protocol  ESPPTViewDelegate <NSObject>
@optional
- (void)pptView:(ESPPTView *)view scrollAtIndex:(NSUInteger)index;
- (void)pptView:(ESPPTView *)view tapPageAtIndex:(NSUInteger)index;
@end

@interface ESPPTView : UIView

@property (weak, nonatomic) id <ESPPTViewDelegate> delegate;
@property (readonly) NSUInteger pageCount;
- (instancetype)initWithFrame:(CGRect)frame cachePath:(NSString *)path;
- (void)fillImageWithPhotoUrls:(NSArray *)photoUrls;
- (void)scrollToItemAtIndex:(NSInteger)item;
- (void)nextPage;
- (void)previousPage;

@end
