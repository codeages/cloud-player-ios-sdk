//
//  ESCloudSDKLog.h
//  AFNetworking
//
//  Created by aaayi on 2019/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
void ESCloudLog(NSString *domain, const char *function, NSString *format, ...);
@interface ESCloudSDKLog : NSObject

@end

NS_ASSUME_NONNULL_END
