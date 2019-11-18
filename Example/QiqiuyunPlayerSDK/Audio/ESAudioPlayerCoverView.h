//
//  ESAudioPlayerCoverView.h
//  EduSoho
//
//  Created by LiweiWang on 2016/12/16.
//  Copyright © 2016年 Kuozhi Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESAudioPlayerCoverView : UIView

@property (assign, nonatomic) BOOL isFullScreen;
@property (copy, nonatomic) NSString *coverImageUrl;

+ (ESAudioPlayerCoverView *)createdAudioPlayerCoverView;
- (void)startRotating;
- (void)stopRotating;

@end
