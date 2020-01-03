//
//  ESMediaPlayerModel.h
//  ESMediaPlayerSDK_Example
//
//  Created by aaayi on 2019/10/23.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESMediaPlayerHtmlModel : NSObject
@property (readonly) NSURL *baseURL;

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *encryptKey;
@property (nonatomic, copy) NSString *iv;
@end

@interface ESMediaPlayerAnimationModel : NSObject
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *encryptKey;
@property (nonatomic, copy) NSString *infoUrl;
@property (nonatomic, copy) NSString *pageUrlPrefix;
@property (nonatomic, copy) NSString *iv;
@property (nonatomic, copy) NSString *resourceUri;
@property (nonatomic, copy) NSString *subs;
@property (nonatomic, copy) NSString *playerVersion;

@end

@interface ESMediaPlayerSubtitlesModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;

@end



@interface ESMediaPlayerArgsModel : NSObject
@property (nonatomic, copy) NSString *playlist;
@property (nonatomic, copy) NSString *playlistType;
@property (nonatomic, copy) NSString *watermarkUrl;
@property (nonatomic, copy) NSString *player;
@property (nonatomic, copy) NSString *webViewUrl;
@property (nonatomic, copy) NSString *followToken;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray<NSDictionary *> *subtitles;
@property (nonatomic, strong) ESMediaPlayerHtmlModel *html;
@property (nonatomic, strong) ESMediaPlayerAnimationModel *animation;
@property (nonatomic, assign) BOOL isPreview;
@property (nonatomic, assign) NSTimeInterval headLength;

@end

@interface ESMediaPlayerModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) ESMediaPlayerArgsModel *args;
@property (nonatomic, readonly) NSUInteger mediType;
@end


@interface ESMediaVideoModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSURL *localURL;
@property (nonatomic, assign) NSInteger bandwidth;
@property (nonatomic, assign) NSInteger definition;
@end

@interface ESMediaPlayerErrorModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *trace_id;

@end

@interface ESMediaPlayerResultModel : NSObject
@property (nonatomic, strong) ESMediaPlayerErrorModel *error;

@end

NS_ASSUME_NONNULL_END
