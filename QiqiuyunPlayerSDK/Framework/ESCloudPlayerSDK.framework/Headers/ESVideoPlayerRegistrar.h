//
//  ESVideoPlayerRegistrar.h
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/22.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ESVideoPlayerRegistrar : NSObject

@property (nonatomic, readonly) UIApplicationState state;

@property (nonatomic, copy, nullable) void(^willResignActive)(ESVideoPlayerRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^didBecomeActive)(ESVideoPlayerRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^willEnterForeground)(ESVideoPlayerRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^didEnterBackground)(ESVideoPlayerRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^newDeviceAvailable)(ESVideoPlayerRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^oldDeviceUnavailable)(ESVideoPlayerRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^categoryChange)(ESVideoPlayerRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^audioSessionInterruption)(ESVideoPlayerRegistrar *registrar);

@end
NS_ASSUME_NONNULL_END
