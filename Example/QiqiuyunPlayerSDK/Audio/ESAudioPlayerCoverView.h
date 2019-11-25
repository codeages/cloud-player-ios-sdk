//
//  ESAudioPlayerCoverView.h
//  EduSoho
//
//  Created by LiweiWang on 2016/12/16.
//  Copyright © 2016年 Kuozhi Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESDefaultVideoControlView.h"

@interface ESAudioPlayerCoverView : ESDefaultVideoControlView
@property (copy, nonatomic) NSString *coverImageUrl;
@property (strong, nonatomic) UIImage *coverImage;
- (void)startRotating;
- (void)stopRotating;
@end
