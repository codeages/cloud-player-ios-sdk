//
//  NSMutableArray+Safe.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/11/28.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Safe)
- (id)safeObject:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
