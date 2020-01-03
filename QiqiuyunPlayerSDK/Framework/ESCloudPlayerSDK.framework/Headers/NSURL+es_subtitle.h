//
//  NSURL+es_subtitle.h
//  AFNetworking
//
//  Created by aaayi on 2019/12/4.
//

#import <Foundation/Foundation.h>
#import "ESSubtitleParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (es_subtitle)
- (void)loadSubtitleWithHandler:(void (^)(NSString *subtitle, NSError *error))handler;
- (void)parserSubtitleWithHandler:(void (^)(ESSubtitleParser *parser, NSError *error))handler;

@end

NS_ASSUME_NONNULL_END
