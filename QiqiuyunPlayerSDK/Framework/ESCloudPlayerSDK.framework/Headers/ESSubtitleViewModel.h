//
//  ESSubtitleViewModel.h
//  ESCloudPlayerSDK
//
//  Created by aaayi on 2019/12/4.
//

#import <Foundation/Foundation.h>
#import "ESSubtitleItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface ESSubtitleViewModel : NSObject
@property (nonatomic, strong) ESSubtitleItem *subtitleItem;
@property (nonatomic, weak) UILabel *subtitleLabel;
@property (nonatomic, assign) BOOL enable;

@end

NS_ASSUME_NONNULL_END
