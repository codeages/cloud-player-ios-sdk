//
//  ESDownloadViewController.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/11/28.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESDownloadViewController.h"
#import "ESDownloadingViewController.h"
#import "ESDownloadedViewController.h"
#import "ESDownloadContainerViewController.h"
#import "ESVideoViewController.h"
#import "ESDownloadTableViewCell.h"

#import <YYKit/YYKit.h>
#import "ESJWTTokenTool.h"
#import "ESDownloadResourceModel.h"
#import "ESAppDelegate.h"

@interface ESDownloadViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<ESDownloadResourceModel *> *m3u8Files;
//@property (weak, nonatomic) ESDownloadManager *downloadMgr;

@property (weak, nonatomic) ESM3U8DownloadManager *m3u8Mgr;

@end

@implementation ESDownloadViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.m3u8Mgr = ((ESAppDelegate *)[UIApplication sharedApplication].delegate).m3u8Mgr;
    self.title = @"EduSoho系统介绍课程";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"course-introduction"]];
    imageView.frame = CGRectMake(0, 0, 0, 120);
    self.tableView.tableHeaderView = imageView;
    [self.tableView registerNib:[UINib nibWithNibName:@"ESDownloadTableViewCell" bundle:nil] forCellReuseIdentifier:@"ESDownloadTableViewCell"];
//    self.downloadMgr = [ESDownloadManager defaultManager];

#if ESDEBUG
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DownloadResource_dev" ofType:@"plist"];
#else
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DownloadResource" ofType:@"plist"];
#endif
    NSArray *files = [[NSArray alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path]];
    self.m3u8Files = [NSArray modelArrayWithClass:[ESDownloadResourceModel class] json:files].mutableCopy;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.m3u8Files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ESDownloadTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ESDownloadResourceModel *resourceModel = [self.m3u8Files objectAtIndex:indexPath.row];
    cell.resNo = resourceModel.resNo;
    cell.title = resourceModel.fileName;
    ESM3U8DownloadTask *task = [self.m3u8Mgr fetchTaskWithResNo:cell.resNo];
    cell.task = task;
    @weakify(self);
    cell.tap = ^(ESM3U8DownloadTask * _Nonnull task) {
        @strongify(self);
        ESDownloadResourceModel *m3u8File = self.m3u8Files[indexPath.row];
        switch (task.status) {
            case ESDownloadStatusUnknow: {
                [self startDownload:m3u8File];
                break;
            }
            case ESDownloadStatusWaiting: {
                [self startDownload:m3u8File];
                break;
            }
            case ESDownloadStatusFailed: {
                [self startDownload:m3u8File];
                break;
            }
            case ESDownloadStatusRunning: {
                [self suspendedDownload:m3u8File.resNo];
                break;
            }
            case ESDownloadStatusWillSuspend:
            case ESDownloadStatusSuspended: {
                [self continueDownload:m3u8File.resNo];
                break;
            }
            case ESDownloadStatusCanceled:
            case ESDownloadStatusRemoved:
            case ESDownloadStatusSucceeded:
            default:
                break;
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ESDownloadResourceModel *m3u8File = self.m3u8Files[indexPath.row];
    ESVideoViewController *vc = [[ESVideoViewController alloc]init];
    vc.resNo = m3u8File.resNo;
    vc.token = m3u8File.token;
    vc.title = m3u8File.fileName;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - action
- (void)success:(NSNotification *)note {
    [self.tableView reloadData];
}

- (void)failure:(NSNotification *)note {
    [self.tableView reloadData];
}

- (IBAction)allDownloadClick:(id)sender {
    [self allDownload];
}

- (void)allDownload {
    NSMutableArray *infos = @[].mutableCopy;
    [self.m3u8Files enumerateObjectsUsingBlock:^(ESDownloadResourceModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        ESM3U8DownloadInfo *info = [[ESM3U8DownloadInfo alloc] initWithFileName:obj.fileName resNo:obj.resNo token:obj.token definition:ESCloudPlayerVideoDefinitionSD];
        [infos addObject:info];
    }];
    @weakify(self);
    [self.m3u8Mgr multiDownloadM3u8:infos handler:^(NSArray<ESM3U8DownloadTask *> * _Nonnull tasks) {
         @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)startDownload:(ESDownloadResourceModel *)info {
    NSString *token = info.token;
    if (!token) {
       token = [ESJWTTokenTool JWTTokenWithPlayload:info.resNo previewTime:0 headResNo:@"" isPlayAudio:YES];
    }
    ESM3U8DownloadInfo *downloadInfo = [[ESM3U8DownloadInfo alloc] initWithFileName:info.fileName resNo:info.resNo token:token definition:ESCloudPlayerVideoDefinitionSD];
    @weakify(self);
    [self.m3u8Mgr downloadM3u8:downloadInfo handler:^(ESM3U8DownloadTask * _Nonnull task) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)continueDownload:(NSString *)resNo {
    [self.m3u8Mgr start:resNo];
}

- (void)suspendedDownload:(NSString *)resNo {
    [self.m3u8Mgr suspend:resNo handler:^(ESM3U8DownloadTask * _Nonnull task) {
        
    }];
}

- (void)cancelDownload:(NSString *)resNo {
    [self.m3u8Mgr cancel:resNo handler:^(ESM3U8DownloadTask *_Nonnull task) {
        
    }];

}

- (void)removeDownload:(NSString *)resNo {
    [self.m3u8Mgr remove:resNo completely:YES handler:^(ESM3U8DownloadTask *_Nonnull task) {
        
    }];

}

@end
