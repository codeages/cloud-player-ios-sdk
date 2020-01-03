//
//  QPScriptMessage.h
//  AFNetworking
//
//  Created by aaayi on 2019/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QPScriptMessage : NSObject
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *callback;
@property (nonatomic, strong) NSDictionary *data;

@end

NS_ASSUME_NONNULL_END
