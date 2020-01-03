//
//  NSString+m3u8.h
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/24.
//  Copyright © 2019 ayia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class M3U8ExtXStreamInfList, M3U8SegmentInfoList;
@interface NSString (m3u8)
/**
 @return "key=value" transform to dictionary
 */
- (NSMutableDictionary *)attributesFromAssignment;

- (BOOL)isM3u8;
- (BOOL)isExtendedM3Ufile;

- (BOOL)isMasterPlaylist;
- (BOOL)isMediaPlaylist;

- (NSString *)stringByRemoveReturnCharacter;
- (NSString *)stringByRemovingEdgeQuoteMark;

- (M3U8SegmentInfoList *)m3u8SegementInfoListValueRelativeToURL:(NSString *)baseURL;

- (NSString *)keyParsing;


@end

NS_ASSUME_NONNULL_END
