//
//  ESHttpServerHelper.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/3.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  M3U8_LOCALHOST @"http://127.0.0.1/"
#define PORT_8080 8080
#define PORT_8081 8081

NS_ASSUME_NONNULL_BEGIN
@interface ESHttpServerHelper : NSObject
@property (strong, nonatomic) NSError *httpServerError;
@property (strong, nonatomic) NSString *directoryPath;
@property (strong, nonatomic) NSNumber *port;
- (void)prepareHttpServer:(NSString *)directoryPath port:(NSNumber *)port handler:(void(^)(NSURL *serverURL, NSError * error))handler;
- (void)stopHttpServer:(void(^)(BOOL isStop))handler;

@end

NS_ASSUME_NONNULL_END
