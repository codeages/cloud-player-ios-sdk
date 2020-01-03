//
//  ESSubtitleParser.h
//  AFNetworking
//
//  Created by aaayi on 2019/12/4.
//

#import <Foundation/Foundation.h>
#import "ESSubtitleItem.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ESSubtitleParserProtocol <NSObject>
- (NSTimeInterval)offsetTime;
- (NSArray<ESSubtitleItem *> *)subtitleItems;
- (NSArray<ESSubtitleItem *> *)parseWithFileContent:(NSString *)fileContent error:(NSError **)error;
- (ESSubtitleItem *)subtitleItemAtTime:(NSTimeInterval)time;
@end
@interface ESSubtitleParser : NSObject<ESSubtitleParserProtocol>
@property (nonatomic, assign)NSTimeInterval offsetTime;
@end

NS_ASSUME_NONNULL_END
