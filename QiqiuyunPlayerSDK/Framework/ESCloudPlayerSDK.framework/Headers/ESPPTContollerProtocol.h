//
//  QPPPTContollerProtocol.h
//  AFNetworking
//
//  Created by aaayi on 2019/11/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ESPPTContollerProtocol <NSObject>
@property (readonly) NSInteger pageCount;
- (void)nextPage;
- (void)previousPage;
- (void)scrollToPageAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END