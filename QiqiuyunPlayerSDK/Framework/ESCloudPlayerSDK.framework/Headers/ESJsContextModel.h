//
//  ESJsContextModel.h
//  AFNetworking
//
//  Created by aaayi on 2019/12/19.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@class ESJsContextModel;
@protocol JSExportProtocol<JSExport>
- (void)postMessage:(id)params;
@property (nonatomic, strong) ESJsContextModel *messageHandlers;
@property (nonatomic, strong) ESJsContextModel *native;
@end

@class JSContext;
@interface ESJsContextModel : NSObject<JSExportProtocol>
@property (nonatomic, copy) void(^callback)(NSString *json);
@property (nonatomic, strong) ESJsContextModel *messageHandlers;
@property (nonatomic, strong) ESJsContextModel *native;

@end

NS_ASSUME_NONNULL_END
