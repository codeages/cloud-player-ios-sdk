//
//  ESDownloadBaseViewController.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/3.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESDownloadBaseViewController : ESBaseViewController
<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong)UIToolbar *bottomToolBar;
@property (nonatomic, strong)UIButton *rightButton;
@property (nonatomic, assign)BOOL shouldEdit;
@property (weak, nonatomic) ESM3U8DownloadManager *m3u8Mgr;
@property (strong, nonatomic) NSMutableArray<ESM3U8DownloadTask *> *tasks;

- (UIBarButtonItem *)rightBarButtonItem;
- (void)m3u8DownloadSuccess:(ESM3U8DownloadTask *)task;
- (void)m3u8DownloadFailure:(ESM3U8DownloadTask *)task;

//- (void)startDownload:(ESDownloadTaskInfo *)info;
//- (void)continueDownload:(ESDownloadTaskInfo *)info;
//- (void)suspendedDownload:(ESDownloadTaskInfo *)info;
//- (void)cancelDownload:(ESDownloadTaskInfo *)info;
//- (void)removeDownload:(ESDownloadTaskInfo *)info;

@end

NS_ASSUME_NONNULL_END
