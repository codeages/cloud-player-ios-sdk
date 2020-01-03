//
//  ESDownloadingViewController.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/3.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESDownloadingViewController.h"

@interface ESDownloadingViewController ()
@end

@implementation ESDownloadingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下载资源";
    UIBarButtonItem *suspuseItem = [[UIBarButtonItem alloc]initWithTitle:@"      全部暂停      " style:UIBarButtonItemStylePlain target:self action:@selector(allSuspuse:)];
    [suspuseItem setTintColor:[UIColor blackColor]];
    UIBarButtonItem *removeItem = [[UIBarButtonItem alloc]initWithTitle:@"      全部清除   " style:UIBarButtonItemStylePlain target:self action:@selector(allRemove:)];
    [removeItem setTintColor:[UIColor redColor]];
    UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc]initWithTitle:@"        " style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *spaceItem2 = [[UIBarButtonItem alloc]initWithTitle:@"        " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.bottomToolBar setItems:@[suspuseItem , spaceItem1, spaceItem2, removeItem] animated:YES];
    
    [self.m3u8Mgr.tasks enumerateObjectsUsingBlock:^(__kindof ESDownloadTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.status != ESDownloadStatusSucceeded) {
            [self.tasks addObject:obj];
        }
    }];
}


#pragma mark -
- (void)allSuspuse:(UIButton *)sender{
    @weakify(self)
    [self.tasks enumerateObjectsUsingBlock:^(ESM3U8DownloadTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
        [task suspend:^(ESM3U8DownloadTask *t) {
            @strongify(self);
            self.tableView.editing = NO;
            self.rightButton.selected = NO;
            self.bottomToolBar.hidden = YES;
            [self.tableView reloadData];
        }];
    }];
}

- (void)allRemove:(UIButton *)sender{
    @weakify(self)
    [self.tasks enumerateObjectsUsingBlock:^(ESM3U8DownloadTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
        [task remove:YES handler:^(ESM3U8DownloadTask *t) {
            @strongify(self);
            self.tableView.editing = NO;
            self.rightButton.selected = NO;
            self.bottomToolBar.hidden = YES;
            [self.tasks removeObject:t];
            [self.tableView reloadData];
        }];
    }];
}

- (void)m3u8DownloadSuccess:(ESM3U8DownloadTask *)task{
    [self.tasks removeObject:task];
    [self.tableView reloadData];
}
- (void)m3u8DownloadFailure:(ESM3U8DownloadTask *)task{
    
}


@end
