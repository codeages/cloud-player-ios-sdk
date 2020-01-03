//
//  ESMediaPlayerNetApi.h
//  ESMediaPlayerSDK_Example
//
//  Created by aaayi on 2019/10/12.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * _Nullable const ESMediaPlayerErrorDomain;
FOUNDATION_EXPORT NSString * _Nullable const ESMediaPlayerErrorKey;

NS_ASSUME_NONNULL_BEGIN
typedef void(^CompletionHandler) (id _Nullable responseObject,  NSError * _Nullable error);
@interface ESMediaPlayerNetwork : NSObject
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPlayerBaseURL:(NSURL * _Nullable)baseURL;
- (instancetype)initWithResourceBaseURL:(NSURL *)baseURL;

- (void)requestMediaSourseWithToken:(NSString *)token resNo:(NSString *)resNo userId:(NSString *)userId userName:(NSString *)userName completionHandler:(CompletionHandler)completionHandler;
- (void)requestPlayListWithURLString:(NSString * _Nonnull)URLString completionHandler:(CompletionHandler)completionHandler;

- (void)startUploadFileRequest:(NSString *)path  name:(NSString *)name no:(NSString *)no extno:(NSString *)extno directives:(NSDictionary<NSString *, NSString *> *)directives isForm:(BOOL)isForm completionHandler:(CompletionHandler)completionHandler;
- (void)finishUploadFileRequest:(NSString *)path  no:(NSString *)no completionHandler:(CompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
