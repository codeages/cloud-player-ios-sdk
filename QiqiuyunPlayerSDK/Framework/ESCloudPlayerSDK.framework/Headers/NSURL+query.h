//
//  NSURL+params.h
//  AFNetworking
//
//  Created by aaayi on 2019/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (query)
- (NSURL *)appendingQuery:(NSDictionary<NSString *, NSString *> *)querys;
@end

NS_ASSUME_NONNULL_END
