//
//  ESBaseTableViewController.h
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/11.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESBaseViewController.h"
#import "ESDownloadResourceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESBaseTableViewController : ESBaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSString *tipText;
@property (strong, nonatomic) NSMutableArray<ESDownloadResourceModel *> *resourceModels;

@end

NS_ASSUME_NONNULL_END
