//
//  ESDownloadBaseViewController.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/3.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESDownloadBaseViewController.h"
#import "ESPlayM3U8FileViewController.h"
#import "ESJWTTokenTool.h"
#import "ESDownloadTableViewCell.h"
#import "ESAppDelegate.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
@interface ESDownloadBaseViewController ()

@end

@implementation ESDownloadBaseViewController
- (NSMutableArray *)tasks{
    if (!_tasks) {
        _tasks = @[].mutableCopy;
    }
    return _tasks;
}

- (UIToolbar *)bottomToolBar{
    if (!_bottomToolBar) {
        CGRect frame  = self.view.bounds;
        CGFloat y = CGRectGetMaxY(frame) - 44 - 44;
        _bottomToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, y, frame.size.width, 44)];
//        UIBarButtonItem *suspuseItem = [[UIBarButtonItem alloc]initWithTitle:@"     全部暂停   " style:UIBarButtonItemStylePlain target:self action:@selector(allSuspuse:)];
//        [suspuseItem setTintColor:[UIColor blackColor]];
//        UIBarButtonItem *removeItem = [[UIBarButtonItem alloc]initWithTitle:@"      全部清除   " style:UIBarButtonItemStylePlain target:self action:@selector(allRemove:)];
//        [removeItem setTintColor:[UIColor redColor]];
//        UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc]initWithTitle:@"        " style:UIBarButtonItemStylePlain target:nil action:nil];
//        UIBarButtonItem *spaceItem2 = [[UIBarButtonItem alloc]initWithTitle:@"        " style:UIBarButtonItemStylePlain target:nil action:nil];
//        UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        UIBarButtonItem *spaceItem2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        _bottomToolBar.hidden = YES;
//        [_bottomToolBar setItems:@[removeItem,spaceItem1, spaceItem2,suspuseItem] animated:YES];
    }
    return _bottomToolBar;
}

- (UIBarButtonItem *)rightBarButtonItem{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_rightButton setTitle:@"取消" forState:UIControlStateSelected];
        [_rightButton addTarget:self action:@selector(editingClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    }
    return [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.m3u8Mgr = ((ESAppDelegate *)[UIApplication sharedApplication].delegate).m3u8Mgr;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRGB:0xFAFAFA];
    [self.tableView registerNib:[UINib nibWithNibName:@"ESDownloadTableViewCell" bundle:nil] forCellReuseIdentifier:@"ESDownloadTableViewCell"];
    [self.view addSubview: self.tableView ];
    [self.view addSubview:self.bottomToolBar];
    
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
         bottom = - [[UIApplication sharedApplication] keyWindow].safeAreaInsets.bottom;
    }
    [self.bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(bottom);
        make.height.equalTo(@(44));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(success:) name:ESM3U8DownloadTaskSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failure:) name:ESM3U8DownloadTaskFailureNotification object:nil];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   ESDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ESDownloadTableViewCell" forIndexPath:indexPath];
    ESM3U8DownloadTask *task = [self.tasks objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.resNo = task.resNo;
    cell.title = task.fileName;
    cell.task = task;
    @weakify(self);
    cell.tap = ^(ESM3U8DownloadTask * _Nonnull task) {
        @strongify(self);
        switch (task.status) {
            case ESDownloadStatusUnknow: {
                [self startDownload:task];
                break;
            }
            case ESDownloadStatusWaiting: {
                [self startDownload:task];
                break;
            }
            case ESDownloadStatusFailed: {
                [self startDownload:task];
                break;
            }
            case ESDownloadStatusRunning: {
                [self suspendedDownload:task];
                break;
            }
            case ESDownloadStatusWillSuspend:
            case ESDownloadStatusSuspended: {
                [self continueDownload:task];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ESDownloadTableViewCell *taskCell = (ESDownloadTableViewCell *)cell;
    @weakify(self)
    @weakify(taskCell)
    [taskCell.task progress:YES handler:^(ESM3U8DownloadTask *t) {
        float progress = 0;
        if (t.progress.totalUnitCount > 0) {
            progress = t.progress.completedUnitCount / (t.progress.totalUnitCount  *1.0);
        }
        if (progress > 1) {
            progress  = 1;
        }
        if (progress < 0) {
            progress  = 0;
        }
        weak_taskCell.progress = progress;
        [weak_taskCell configButtonState:t.status];
    }];
    
    [taskCell.task success:YES handler:^(ESM3U8DownloadTask *t) {
        [weak_taskCell configButtonState:t.status];
    }];
    
    [taskCell.task failure:YES handler:^(ESM3U8DownloadTask *t) {
        [weak_taskCell configButtonState:t.status];
    }];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.tasks.count > indexPath.row) {
            ESM3U8DownloadTask *task = [self.tasks objectAtIndex:indexPath.row];
            @weakify(self)
            [self.m3u8Mgr remove:task.resNo completely:YES handler:^(id t) {
                @strongify(self);
                [self.tableView reloadData];
            }];
        }
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ESM3U8DownloadTask *task = [self.tasks objectAtIndex:indexPath.row];
    if (task.status == ESDownloadStatusSucceeded) {
        ESPlayM3U8FileViewController *vc = [[ESPlayM3U8FileViewController alloc]init];
        vc.resNo = task.resNo;
        vc.title = task.fileName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - action
- (void)success:(NSNotification *)note {
    [self m3u8DownloadSuccess:note.object];
}

- (void)failure:(NSNotification *)note {
    [self m3u8DownloadFailure:note.object];
}

- (void)editingClick:(UIButton *)sender {
    if (self.tasks.count > 0) {
        sender.selected = !sender.isSelected;
        if (self.shouldEdit) {
            self.tableView.editing = !self.tableView.isEditing;
        }
        self.bottomToolBar.hidden = !sender.selected;
    }
}

- (void)startDownload:(ESM3U8DownloadTask *)task{
//    [self.downloadMgr downloadM3U8FileWithToken:info.token resNo:info.resNo fileName:info.fileName];
}

- (void)continueDownload:(ESM3U8DownloadTask *)task{
    [self.m3u8Mgr start:task.resNo];
}

- (void)suspendedDownload:(ESM3U8DownloadTask *)task{
    [self.m3u8Mgr suspend:task.resNo handler:^(id t) {
        
    }];
}

- (void)cancelDownload:(ESM3U8DownloadTask *)task{
    [self.m3u8Mgr cancel:task.resNo handler:^(ESM3U8DownloadTask * _Nonnull info) {
        
    }];
}

- (void)removeDownload:(ESM3U8DownloadTask *)task{
    [self.m3u8Mgr remove:task.resNo completely:YES handler:^(ESM3U8DownloadTask * _Nonnull info) {
        
    }];
}

- (void)m3u8DownloadSuccess:(ESM3U8DownloadTask *)task {
    [self.tableView reloadData];
}

- (void)m3u8DownloadFailure:(ESM3U8DownloadTask *)task {
    [self.tableView reloadData];
}

@end
