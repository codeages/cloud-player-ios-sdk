//
//  NSURL+m3u8.h
//  M3U8Kit
//
//  Created by Frank on 16/06/2017.
//

#import <Foundation/Foundation.h>
#import "M3U8PlaylistModel.h"

@interface NSURL (m3u8)

/**
 return baseURL if exists.
 if baseURL is nil, return [scheme://host]

 @return URL
 */
- (NSURL *)realBaseURL;

/**
 Load the specific url and get result model with completion block.
 
 @param completion when the url resource loaded, completion block could get model and detail error;
 */
- (void)loadM3U8WithBaseURL:(NSURL *)baseURL streamInfIndex:(NSUInteger)index completion:(void (^)(M3U8PlaylistModel *model, NSError *error))completion;
/**
 this method is synchronous. so may be **block your thread** that call this method.
 */
- (NSURL *)restructureM3U8:(NSURL *)baseURL filePath:(NSString *)filePath level:(NSString *)level;
- (void)restructureM3U8:(NSURL *)baseURL filePath:(NSString *)filePath level:(NSString *)level completion:(void (^)(NSURL *URL))completion;

- (void)loadTextAsyncCompletion:(void (^)(NSString *key, NSError *error))completion;
@end
