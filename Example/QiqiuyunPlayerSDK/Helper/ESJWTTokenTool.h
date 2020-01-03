//
//  ESJWTTokenTool.h
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/30.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESJWTTokenTool : NSObject
+ (NSString *)JWTTokenWithPlayload:(NSDictionary *)playload secret:(NSString *)secret;
+ (NSString *)JWTTokenWithPlayload:(NSDictionary *)playload;
+ (NSString *)JWTTokenWithPlayload:(NSString *)resNo previewTime:(NSTimeInterval)previewTime headResNo:(NSString * _Nullable)headResNo isPlayAudio:(BOOL)playAudio;

//+ (NSString *)debugJWTTokenWithPlayload:(NSDictionary *)playload;
//+ (NSString *)debugJWTTokenWithPlayload:(NSString *)resNo previewTime:(NSTimeInterval)previewTime headResNo:(NSString * _Nullable)headResNo isPlayAudio:(BOOL)playAudio;
@end

NS_ASSUME_NONNULL_END
