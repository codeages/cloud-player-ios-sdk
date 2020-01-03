//
//  ESUploadTableViewCell.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/12.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell/MGSwipeTableCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESUploadTableViewCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;

@end

NS_ASSUME_NONNULL_END
