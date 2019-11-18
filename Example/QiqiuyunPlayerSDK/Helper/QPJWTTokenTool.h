//
//  ESJWTTokenTool.h
//  ESMediaPlayerSDK_Example
//
//  Created by aaayi on 2019/10/30.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QPJWTTokenTool : NSObject
+ (NSString *)JWTTokenWithResNo:(NSString *)resNo;
+ (NSString *)JWTTokenWithResNo:(NSString *)resNo playAudio:(NSString *)playAudio;
@end

NS_ASSUME_NONNULL_END
