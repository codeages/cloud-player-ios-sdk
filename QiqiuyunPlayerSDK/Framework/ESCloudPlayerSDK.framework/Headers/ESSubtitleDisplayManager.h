//
//  ESSubtitleDisplayManager.h
//  ESCloudPlayerSDK
//
//  Created by aaayi on 2019/12/4.
//

#import <Foundation/Foundation.h>
#import "ESSubtitleParser.h"
NS_ASSUME_NONNULL_BEGIN

@interface ESSubtitleDisplayManager : NSObject
@property (nonatomic, strong, readonly) id<ESSubtitleParserProtocol> subtitleParser;
@property (nonatomic, weak, readonly) UILabel *subtitleLabel;

+ (instancetype)managerWithParser:(id<ESSubtitleParserProtocol>)subtitleParser attachToLabel:(UILabel *)subtitleLabel;
- (void)showSubtitleWithTime:(NSTimeInterval)time;
@end

NS_ASSUME_NONNULL_END
