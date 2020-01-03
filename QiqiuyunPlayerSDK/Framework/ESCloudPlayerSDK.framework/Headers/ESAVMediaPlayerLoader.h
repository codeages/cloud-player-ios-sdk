//
//  ESAVMediaPlayerLoader.h
//  ESMediaPlayerSDK_Example
//
//  Created by aaayi on 2019/10/21.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESAVMediaPlayer.h"
#import "ESVideoPlayerPlayDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESAVMediaPlayerLoader : NSObject

+ (ESAVMediaPlayer *)loadPlayerForMedia:(id<ESMediaModelProtocol>)media;
+ (void)clearPlayerForMedia:(id<ESMediaModelProtocol>)media;

@end

NS_ASSUME_NONNULL_END
