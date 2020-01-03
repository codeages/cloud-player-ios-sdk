//
//  M3U8Parser.h
//  M3U8Kit
//
//  Created by Oneday on 13-1-11.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M3U8MediaPlaylist.h"
#import "M3U8Kit.h"

#define INDEX_PLAYLIST_NAME        @"index.m3u8"

#define PREFIX_MAIN_MEDIA_PLAYLIST @"main_media_"
#define PREFIX_AUDIO_PLAYLIST      @"x_media_audio_"
#define PREFIX_SUBTITLES_PLAYLIST  @"x_media_subtitles_"

@interface M3U8PlaylistModel : NSObject

@property (readonly, nonatomic, copy) NSURL *baseURL;
@property (readonly, nonatomic, copy) NSURL *originalURL;

// 如果初始化时的字符串是 media playlist, masterPlaylist为nil
// M3U8PlaylistModel 默认会按照《需要下载的内容》规则选取默认的playlist，如果需要手动指定获取特定的media playlist, 需调用方法 -specifyVideoURL:(这个在选取视频源的时候会用到);

@property (readonly, nonatomic, strong) M3U8MasterPlaylist *masterPlaylist;
@property (nonatomic, strong) M3U8ExtXStreamInf *currentXStreamInf;
@property (readonly, nonatomic, strong) M3U8MediaPlaylist *mainMediaPl;
- (void)changeMainMediaPlWithPlaylist:(M3U8MediaPlaylist *)playlist;
//@property (readonly, nonatomic, strong) M3U8MediaPlaylist *audioPl;
@property (readonly, nonatomic, strong) M3U8MediaPlaylist *subtitlePl;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *keys;

/**
 this method is synchronous. so may be **block your thread** that call this method.
 
 @param URL M3U8 URL
 @param error error pointer
 @return playlist model
 */
- (id)initWithURL:(NSURL *)URL error:(NSError **)error;
- (id)initWithString:(NSString *)string baseURL:(NSURL *)URL error:(NSError **)error;
- (id)initWithString:(NSString *)string originalURL:(NSURL *)originalURL baseURL:(NSURL *)baseURL streamInfIndex:(NSUInteger)index error:(NSError **)error;

// 改变 mainMediaPl
// 这个url必须是master playlist 中多码率url(绝对地址)中的一个
// 这个方法先会去获取url中的内容，生成一个mediaPlaylist，如果内容获取失败，mainMediaPl改变失败
- (void)specifyVideoURL:(NSURL *)URL completion:(void (^)(BOOL success))completion;

- (NSString *)indexPlaylistName;

- (NSString *)prefixOfSegmentNameInPlaylist:(M3U8MediaPlaylist *)playlist;
- (NSString *)sufixOfSegmentNameInPlaylist:(M3U8MediaPlaylist *)playlist;

- (NSArray *)segmentNamesForPlaylist:(M3U8MediaPlaylist *)playlist;

// segment name will be formatted as ["%@%d.%@", prefix, index, sufix] eg. main_media_1.ts
//- (void)savePlaylistsToPath:(NSString *)path error:(NSError **)error;
- (void)savePlaylistsToPath:(NSString *)path error:(NSError **)error completeHandler:(void(^)(NSString *indexM3u8Text, NSString *mainMediaText))completeHandler;
@end












