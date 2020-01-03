//
//  ESDocumentView.h
//  AFNetworking
//
//  Created by aaayi on 2019/11/7.
//

#import <WebKit/WebKit.h>
#import "QPScriptMessage.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ESDocumentViewDelegate;
@interface ESDocumentView : UIView
@property (nonatomic, weak) id<ESDocumentViewDelegate> delegate;
- (void)loadResourceWithURL:(NSURL*)URL;
- (void)nextPage;
- (void)previousPage;
- (void)scrollToPageAtIndex:(NSUInteger)index;
- (void)stopLoading;
@end

@protocol ESDocumentViewDelegate <NSObject>
@optional
- (void)documentView:(ESDocumentView *)webView didReceiveAction:(QPScriptMessage *)message;
- (void)documentView:(ESDocumentView *)webView didFailLoadWithError:(nullable NSError *)error;
@end


NS_ASSUME_NONNULL_END
