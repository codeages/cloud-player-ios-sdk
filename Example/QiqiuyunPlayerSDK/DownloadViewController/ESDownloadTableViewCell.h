//
//  ESDownloadTableViewCell.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/11/28.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DownloadButton/PKDownloadButton.h>
NS_ASSUME_NONNULL_BEGIN

@class ESM3U8DownloadTask;
@interface ESDownloadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet PKDownloadButton *downloadButton;
@property (copy, nonatomic) void(^tap)(ESM3U8DownloadTask *task);
@property (copy, nonatomic) NSString *resNo;
@property (copy, nonatomic) NSString *title;
@property (nonatomic, assign) float progress;
- (void)loadCellData:(id)data;
- (void)configButtonState:(ESDownloadStatus)status;
@property (nonatomic, weak) ESM3U8DownloadTask *task;
@end

NS_ASSUME_NONNULL_END
