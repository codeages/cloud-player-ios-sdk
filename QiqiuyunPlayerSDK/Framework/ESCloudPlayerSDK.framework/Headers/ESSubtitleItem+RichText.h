//
//  ESSubtitleItem+RichText.h
//  ESCloudPlayerSDK
//
//  Created by aaayi on 2019/12/4.
//


#import "ESSubtitleItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESSubtitleItem (RichText)
@property (nonatomic, copy, readonly) NSAttributedString *attributedText;
@end

NS_ASSUME_NONNULL_END
