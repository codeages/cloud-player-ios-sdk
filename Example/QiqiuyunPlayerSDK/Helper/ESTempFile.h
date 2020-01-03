//
//  ESTempFile.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/19.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESTempFile : NSObject
+ (NSURL *)createTempfileWithSize:(int)size;
+ (void)removeTempfile:(NSURL *)path;

@end

NS_ASSUME_NONNULL_END
