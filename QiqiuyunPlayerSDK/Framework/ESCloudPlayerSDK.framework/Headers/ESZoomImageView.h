//
//  ESZoomImageView.h
//  EduSoho
//
//  Created by LiweiWang on 2017/2/22.
//  Copyright © 2017年 Kuozhi Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESZoomImageView : UIView

@property (copy, nonatomic) void (^singleTouch)(void);

- (void)setImageWithURL:(NSString *)imageString cachePath:(NSString *)path;

@end
